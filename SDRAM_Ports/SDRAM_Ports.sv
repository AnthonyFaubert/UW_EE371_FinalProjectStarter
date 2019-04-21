// Author: Anthony Faubert (deadbeef@uw.edu)

`timescale 1 ns / 1 ps

// Provides read and write ports for the SDRAM to the rest of the project
module SDRAM_Ports (
         input logic clk, rst,

         // Port C: camera write port
         input logic portC_clk, portC_aclr, portC_write,
         input logic [24:0] portC_addr,
         input logic [9:0] portC_din,

         // Port V: VGA read port
         input logic portV_clk, portV_arst, portV_nextDout,
         input logic [24:0] portV_readOffset,
         input logic [9:0] portV_VGAx, portV_VGAy, // VGA is 800x525 with 640x480 of that being visible, 2^10 > 800
         output logic [15:0] portV_dout,

         // Port 0: General-purpose read/write port
         input logic port0_clk0, port0_aclr0, port0_clk1, port0_aclr1, port0_wrreq, port0_rdreq, port0_read,
         output logic port0_full, port0_empty,
         input logic [24:0] port0_addr,
         input logic [15:0] port0_din,
         output logic [40:0] port0_dout,

         // Add your own custom ports


         // SDRAM I/O, connect to top-level SDRAM I/O //
         inout [15:0] DRAM_DQ, // Data input/output port. Each data word is 16 bits = 2 bytes
         output logic [12:0] DRAM_ADDR, // row/column ADDRess, depending on command specified by row/column strobes
         output logic [1:0] DRAM_BA, // Bank Address. the SDRAM is split into 4 equal banks
         output logic DRAM_CAS_N, // ColumnAddressStrobe, active-low
         output logic DRAM_CKE, // ClocKEnable, active-high
         output logic DRAM_CLK, // CLocK
         output logic DRAM_CS_N, // ChipSelect, active-low
         output logic DRAM_LDQM, // Low DQ (data port) Mask, can be used to ignore the lower byte of the data port (DQ[7:0]) during a write operation
         output logic DRAM_RAS_N, // RowAddressStrobe, active-low
         output logic DRAM_UDQM, // Upper DQ Mask, same as LDQM, but for the upper byte (DQ[15:8]) instead of the lower one
         output logic DRAM_WE_N // WriteEnable, active-low
      );
   localparam VGA_NULL_DATA_COLOR = {6'd0, 10'd500}; // only bottom 10 bits used, the value should result in a gray color
   // If you're having lots of null data color, try increasing this margin
   // WARNING: do not set to 216832 or higher! (2^19 - 640*480 - 256 (size of cmdb))
   localparam VGA_READ_AHEAD_MARGIN = 19'd50; // AOI
   
   logic [7:0] cmdbUsedw; // How full the SDRAM cmd FIFO is (from 0-255)
   
   
   // Camera->SDRAM write data FIFO
   logic 	      rdPortC, PortCempty, PortCthreshold;
   logic [7:0] 	      PortCusedw;
   logic [9:0] 	      PortCword;
   logic [24:0]       PortCaddr;
   logic [41:0]       PortCcmd;
   FIFO_PortC portCFIFO (
			 .aclr(portC_aclr),
			 .wrclk(portC_clk), .wrreq(portC_write), .data({portC_addr, portC_din}),
			 
			 .rdclk(clk), .rdreq(rdPortC), .rdempty(PortCempty), .rdusedw(PortCusedw), .q({PortCaddr, PortCword})
			 );
   assign PortCcmd = {1'b1, // PortC always writes
		       PortCaddr,
		       6'd0, PortCword // only 10 bits of useful data to write
		       };
   // Urgently flush PortC when the FIFO is nearing full
   assign PortCthreshold = (PortCusedw > 8'd200);


   // General-purpose read-write port FIFO
   logic 	      rdPort0, Port0empty, Port0threshold;
   logic [7:0] 	      Port0usedw;
   logic [41:0]       Port0cmd;
   FIFO_Port0cmd port0FIFOcmd (
			 .aclr(port0_aclr0),
			 .wrclk(port0_clk0), .wrreq(port0_rdreq | port0_wrreq), .wrfull(port0_full), .data({port0_wrreq, port0_addr, port0_din}),
			 
			 .rdclk(clk), .rdreq(rdPort0), .rdempty(Port0empty), .rdusedw(Port0usedw), .q(Port0cmd)
			 );
   // Urgently flush Port0 when the FIFO is nearing full
   assign Port0threshold = (Port0usedw > 8'd200);

   
   // portV_clk domain -> clk domain syncronizers so we can use VGA x,y and portV_readOffset in the SDRAM clock domain
   logic [24:0] readOffset, readOffsetMS;
   logic [9:0] 	VGAx, VGAxMS, VGAy, VGAyMS;
   always_ff @(posedge clk) begin
      {readOffset, readOffsetMS} <= {readOffsetMS, portV_readOffset};
      {VGAx, VGAxMS} <= {VGAxMS, portV_VGAx};
      {VGAy, VGAyMS} <= {VGAyMS, portV_VGAy};
   end

   // Generate a good address to read from based off of the VGA x,y (pretends to be a FIFO)
   logic rdPortV, PortVthreshold, PortVempty;
   assign PortVthreshold = 0; // not a fifo, can't get full
   logic [41:0] PortVcmd;
   assign PortVcmd[41] = 1'b0; // PortV always reads
   assign PortVcmd[15:0] = 'X;
   logic xyInBounds;
   logic [18:0] currentPixelAddress; // 2^19 > 640*480
   logic [24:0] desiredPixelAddress, lastDesiredPixAddr;
   always_comb begin
      xyInBounds = (VGAx < 10'd640) & (VGAy < 10'd480);
      // currentPixelAddress = 640*VGAy + VGAx
      currentPixelAddress = {VGAy, 9'd0} + {2'd0, VGAy, 7'd0} + {9'd0, VGAx};
      // VGA_READ_AHEAD_MARGIN should be adjusted so that emptying the command buffer (cmdbUsedw/2 cycles) plus VGA_READ_AHEAD_MARGIN clock cycles is enough time for a value to be read to prevent the PortV output FIFO from emptying
      // desiredPixelAddress = readOffset + currentPixelAddress + VGA_READ_AHEAD_MARGIN + cmdbUsedw
      desiredPixelAddress = readOffset + 
{6'd0,( currentPixelAddress + VGA_READ_AHEAD_MARGIN + {11'd0, cmdbUsedw} )};
   end
   always_ff @(posedge clk) begin
      if (rst) begin
	 {PortVempty, PortVcmd[40:16]} <= 0;
      end else begin
	 if (xyInBounds) begin
	    // If it's a new value, we haven't sent it
	    if (PortVcmd[40:16] != desiredPixelAddress) PortVempty <= 0;
	    
	    PortVcmd[40:16] <= desiredPixelAddress;
	 end
	 
	 // If the request is being sent to the SDRAM, it's now an old value
	 if (rdPortV) PortVempty <= 1;
      end
   end

	 
   // cmdb: command buffer
   logic 	      cmdSend, cmdbFull, lastCmdWasWrite, nlastCmdWasWrite;
   // [7:0] cmdbUsedw defined above

   logic [9:0] 	      refreshCountdown;
   
   // write: {1'b1, 25'address, 16'data}, read: {1'b0, 25'address, 16'dontcare}
   logic [41:0]       command;
   
   logic [14:0]       presentRow, nextRow;
   always_comb begin
      // Default to not doing anything
      cmdSend = 0;
      command = 'X;
      rdPortC = 0;
      rdPortV = 0;
      rdPort0 = 0;
      nextRow = presentRow;
      nlastCmdWasWrite = lastCmdWasWrite;
      
      // Can't issue any commands if the command buffer is full
      if (~cmdbFull) begin
	 // Do the following behaviors in order of priority if their conditions are met:
	 // 0: do Port0 commands to prevent it from filling
	 // 1: do PortV commands to prevent it from emptying
	 // 2: do PortC commands to prevent it from filling
	 // 3: continue writing. do a write from Port0 on the present row
	 // 4: continue writing. do a write from PortC on the present row
	 // 5: do a read from Port0 on the present row
	 // 6: do a read from PortV on the present row
	 // 7: do a write from Port0 on a new row
	 // 8: do a write from PortC on a new row
	 // 9: do a  read from Port0 on a new row
	 //10: do a  read from PortV on a new row
	 //11: idle
	 // Note: writes are prioritized over reads because switching from write->read is free but read->write incurrs a (3-cycle?) bus delay because of the SDRAM protocol.
	 
	 // It should be noted that I came up with these priorities without knowing anything specific to your project. I tried to make the best general implementation I could based on previous projects, and the result is more complex than I wanted it to be.
	 // In projects that need lower SDRAM latencies and can tolerate poor camera / VGA performance, you may want to prioritize Port0 commands on new rows over PortC/V commands on the current row, for example.
	 // I encourage you to change the logic however you see fit. That said: "If it ain't broke, don't fix it." I would recommend making sure you don't run out of time for other things in your project before messing around with things in this file, as they may be difficult to debug.

	 if (Port0threshold) begin
	    // Don't let Port0 fill
	    cmdSend = 1;
	    rdPort0 = 1;
	    command = Port0cmd;
	 end else if (PortVthreshold) begin
	    // Don't let PortV empty
	    cmdSend = 1;
	    rdPortV = 1;
	    command = PortVcmd;
	 end else if (PortCthreshold) begin
	    // Don't let PortC fill
	    cmdSend = 1;
	    rdPortC = 1;
	    command = PortCcmd;
	 end else if (lastCmdWasWrite & ~Port0empty & Port0cmd[41] & (Port0cmd[40:26] == presentRow)) begin
	    // Write from Port0 if the command is a write on the current row
	    cmdSend = 1;
	    rdPort0 = 1;
	    command = Port0cmd;
	 end else if (lastCmdWasWrite & ~PortCempty & (PortCcmd[40:26] == presentRow)) begin
	    // Write from PortC if it's to the current row
	    cmdSend = 1;
	    rdPortC = 1;
	    command = PortCcmd;
	 end else if (~Port0empty & ~Port0cmd[41] & (Port0cmd[40:26] == presentRow)) begin
	    // Read cmd from Port0 if the command is a read on the current row
	    cmdSend = 1;
	    rdPort0 = 1;
	    command = Port0cmd;
	 end else if (~PortVempty & (PortVcmd[40:26] == presentRow)) begin
	    // Read cmd from PortV if it's on the current row
	    cmdSend = 1;
	    rdPortV = 1;
	    command = PortVcmd;
	 end else if (~Port0empty & Port0cmd[41]) begin
	    // Write from Port0 on a new row
	    cmdSend = 1;
	    rdPort0 = 1;
	    command = Port0cmd;
	 end else if (~PortCempty) begin
	    // Write from PortC on a new row
	    cmdSend = 1;
	    rdPortC = 1;
	    command = PortCcmd;
	 end else if (~Port0empty) begin
	    // Read cmd from Port0 on a new row
	    cmdSend = 1;
	    rdPort0 = 1;
	    command = Port0cmd;
	 end else if (~PortVempty) begin
	    // Read cmd from Port0 on a new row
	    cmdSend = 1;
	    rdPortV = 1;
	    command = PortVcmd;
	 end // else we're idle

	 // If we sent a command, record whether it was a read or write
	 if (cmdSend) nlastCmdWasWrite = command[41];
	 else nlastCmdWasWrite = lastCmdWasWrite;
      end
   end
   always_ff @(posedge clk) begin
      if (rst) begin
	 lastCmdWasWrite <= 1;
	 presentRow <= '0;
      end else begin
	 lastCmdWasWrite <= nlastCmdWasWrite;
	 presentRow <= nextRow;
      end
   end
   
   logic readValid;
   logic [24:0] raddr;
   logic [15:0] rdata;
   EasySDRAM #(.CLOCK_PERIOD(8)) sdram (
         .clk, .rst,
         .write(cmdSend), .full(cmdbFull), .fifoUsage(cmdbUsedw),
         .isWrite(command[41]), .address(command[40:16]), .writeMask(2'b11), .writeData(command[15:0]),
         .readValid, .raddr, .rdata,
         // Keep the row open when idle unless a refresh is imminent
         .keepOpen(refreshCountdown > 10'd50),
         .busy(), .rowOpen(), .refreshCountdown,
         .DRAM_DQ, .DRAM_ADDR, .DRAM_BA, .DRAM_CAS_N, .DRAM_CKE,
         .DRAM_CLK, .DRAM_CS_N, .DRAM_LDQM, .DRAM_RAS_N, .DRAM_UDQM, .DRAM_WE_N
      );

   // PortV output data FIFO ([7:0] PortVout_wrreq defined near PortV cmd FIFO)
   logic PortVout_nullData, PortVout_wrreq;
   logic [8:0] PortVout_usedw;
   FIFO_PortVout portVFIFOout (
			 .aclr(portV_arst),
			 .wrclk(clk), .wrreq(PortVout_wrreq), .data(PortVout_nullData ? VGA_NULL_DATA_COLOR : rdata), .wrusedw(PortVout_usedw),
			 
			 .rdclk(portV_clk), .rdreq(portV_nextDout), .q(portV_dout)
			 );
   // Write the correct rdata to the PortV output FIFO and prevent it from becoming empty with dummy data when necessary
   logic [18:0] VGA_addrTracker, nextVGA_addrTracker;
	logic addrMatches;
   always_comb begin
		addrMatches = (raddr == ({6'd0, VGA_addrTracker} + portV_readOffset));
      if ( addrMatches & readValid ) begin
	 // Readout is valid at the correct VGA_addrTracker in the right order
	 PortVout_wrreq = 1;
	 PortVout_nullData = 0;
	 // VGA_addrTracker = (VGA_addrTracker + 1) % (640*480)
	 nextVGA_addrTracker = (VGA_addrTracker == 19'd307199) ? 19'd0 : (VGA_addrTracker + 19'd1);
      end else if (PortVout_usedw <= 9'd1) begin
	 // Output FIFO might be about to be empty, prevent that from ever happening by writing dummy data
	 PortVout_wrreq = 1;
	 PortVout_nullData = 1;
	 // VGA_addrTracker = (VGA_addrTracker + 1) % (640*480)
	 nextVGA_addrTracker = (VGA_addrTracker == 19'd307199) ? 19'd0 : (VGA_addrTracker + 19'd1);
      end else begin
	 // Do nothing
	 PortVout_wrreq = 0;
	 PortVout_nullData = 0;
	 nextVGA_addrTracker = VGA_addrTracker;
      end
   end
   always_ff @(posedge clk, posedge portV_arst) begin
      if (portV_arst) VGA_addrTracker <= 0;
      else VGA_addrTracker <= nextVGA_addrTracker;
   end
   
   // Port0 readout FIFO
   logic Port0filter;
   FIFO_Port0out port0FIFOout (
			 .aclr(port0_aclr1),
			 .wrclk(clk), .wrreq(readValid & Port0filter), .data({raddr, rdata}),
			 
			 .rdclk(port0_clk1), .rdreq(port0_read), .rdempty(port0_empty), .q(port0_dout)
			 );
   // Read filtering should be done here
   always_comb begin // AOI
      // Don't spam Port0 with VGA data
      // Port0filter = 1 iff raddr outside of [offset+640*480 - 1 : offset]
      Port0filter = (raddr < portV_readOffset) & ((25'd307199 + portV_readOffset) < raddr);
   end
endmodule

module SDRAM_Ports_tb ();
   logic clk, rst,
	 portC_clk, portC_aclr, portC_write,
	 portV_clk, portV_arst, portV_nextDout,
	 port0_clk0, port0_aclr0,
	 port0_clk1, port0_aclr1, port0_wrreq, port0_rdreq,
	 port0_read, port0_full, port0_empty;
   logic [24:0] portC_addr, portV_readOffset, port0_addr;
   logic [9:0] 	portC_din, portV_VGAx, portV_VGAy;
   logic [15:0] port0_din, portV_dout;
   logic [40:0] port0_dout;

   tri [15:0] DRAM_DQ;
   logic [12:0] DRAM_ADDR;
   logic [1:0] DRAM_BA;
   logic DRAM_CAS_N, DRAM_CKE, DRAM_CLK, DRAM_CS_N, DRAM_LDQM, DRAM_RAS_N, DRAM_UDQM, DRAM_WE_N;
   
   SDRAM_Ports dut (.*);

   // Setup clocks
   initial begin
      clk = 0;
      forever #8 clk = ~clk; // 125 MHz
   end
   initial begin
      portV_clk = 0;
      forever #20 portV_clk = ~portV_clk; // 50 MHz
   end
   initial begin
      portC_clk = 0;
      forever #25 portC_clk = ~portC_clk; // 40 MHz
   end
   assign {port0_clk0, port0_clk1} = {2{portV_clk}};

   initial begin
      {portC_write, portV_nextDout, port0_wrreq, port0_rdreq, port0_read, portC_addr, portV_readOffset, port0_addr, portC_din, port0_din} = '0;
      {rst, portC_aclr, portV_arst, port0_aclr0, port0_aclr1} = '1; #30;
      {rst, portC_aclr, portV_arst, port0_aclr0, port0_aclr1} = '0; #30;

      assert(port0_empty);
      assert(^portV_dout !== 1'bX); // portV_dout must be defined by now

      repeat (5000) @(posedge clk);
      
      $stop;
   end
endmodule
