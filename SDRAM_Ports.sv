
// TODO: delete this note
// write clk = MIPI_PIXEL_CLK_, wr dat = LUT_MIPI_PIXEL_D[9:0], wren = LUT_MIPI_PIXEL_HS & LUT_MIPI_PIXEL_VS, wr_async_clr = !DLY_RST_0
// rd clk = VGA_CLK, rd dat = SDRAM_RD_DATA[9:0], rden = READ_Request, rd_async_clr = !DLY_RST_1


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
         output logic [9:0] portV_dout,

         // Port 0: General-purpose read/write port
         input logic port0_clk0, port0_aclr0, port0_clk0, port0_aclr0, port0_wrreq, port0_rdreq, port0_read,
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
   localparam VGA_NULL_DATA_COLOR = 24'hEA00FF; // A nice pinkish-purple color
   
   // Camera->SDRAM write data FIFO
   logic 	      rdPortC, PortCempty, PortCthreshold;
   logic [7:0] 	      PortCusedw;
   logic [9:0] 	      PortCword;
   logic [24:0]       PortCaddr;
   logic [41:0]       PortCcmd;
   FIFO_PortC portCFIFO (2
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
   FIFO_Port0 port0FIFO (
			 .aclr(port0_aclr0),
			 .wrclk(port0_clk0), .wrreq(port0_rdreq | port0_wrreq), .data({port0_wrreq, port0_addr, port0_din}),
			 
			 .rdclk(clk), .rdreq(rdPort0), .rdempty(Port0empty), .rdusedw(Port0usedw), .q(Port0cmd)
			 );
   // Urgently flush Port0 when the FIFO is nearing full
   assign Port0threshold = (Port0usedw > 8'd200);


   // SDRAM->VGA read command FIFO, automatically driven
   logic 	      rdPortV, PortVempty, PortVthreshold, PortVwrreq;
   logic [7:0] 	      PortVusedw;
   logic [24:0]       PortVaddr;
   logic [41:0]       PortVcmd;
   FIFO_PortV portCFIFO (
			 .aclr(portV_arst),
			 .wrclk(clk), .wrreq(PortVwrreq), .data({6'd0, PortVaddr} + portV_readOffset),
			 
			 .rdclk(clk), .rdreq(rdPortV), .rdempty(PortVempty), .rdusedw(PortVusedw), .q(PortVcmd[40:16])
			 );
   assign PortVcmd[41] = 1'b0; // PortV always reads
   assign PortVcmd[15:0] = 'X;
   // Urgently flush PortV when the FIFO is nearing full
   assign PortVthreshold = (PortVusedw > 8'd200);
   // Automated address generation for PortV
   logic [18:0]       PortVaddr; // 2^19 > 640*480
   always_ff @(posedge clk, posedge portV_arst) begin
      if (portV_arst) begin
	 PortVaddr <= '0;
      end else begin
	 if (TODO) begin // only do this if we're running low on data in the PortV readout FIFO, better algorithm?
	    // PortVaddr = (PortVaddr + 1) % (640*480)
	    PortVaddr <= (PortVaddr == 19'd307199) ? '0 : (PortVaddr + 19'd1);
	 end else begin
	    PortVaddr <= PortVaddr;
	 end
      end
   end
   
   // cmdb: command buffer
   logic 	      cmdSend, cmdbFull, lastCmdWasWrite, nlastCmdWasWrite;
   logic [7:0] 	      cmdbUsedw;
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
	 end
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

   // Read filtering should be done here
   
endmodule
