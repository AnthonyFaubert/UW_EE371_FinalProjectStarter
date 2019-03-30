
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
	 // 5: do a read from PortV on the present row
	 // 6: do a read from Port0 on the present row
	 // 7: do a write from Port0 on a new row
	 // 8: do a write from PortC on a new row
	 // 9: do a  read from PortV on a new row
	 //10: do a  read from Port0 on a new row
	 //11: idle

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
	    // Write from Port0
	    cmdSend = 1;
	    rdPort0 = 1;
	    command = Port0cmd;
	 end else if (lastCmdWasWrite & ~PortCempty & (PortCcmd[40:26] == presentRow)) begin
	    // Write from PortC
	    cmdSend = 1;
	    rdPortC = 1;
	    command = PortCcmd;
	 end else if (~PortVempty & (PortVcmd[40:26] == presentRow)) begin

	 end else if (~Port0empty & ~Port0cmd[41] & (Port0cmd[40:26] == presentRow)) begin
	 end else if (~Port0empty & ) begin
	    end else if (~Port0empty 
	 end else begin
	    
	    end else if ((PortCdata[34:11] == presentRow) & ~PortCempty) begin
	       // Write from PortC
	       cmdSend = 1;
	       rdPortC = 1;
	       command = {1'b1,
			  PortCdata[34:10],
			  6'd0, PortCdata[9:0] // only 10 bits of useful data to write
			  };
	    end else begin
	       if (Port0
	    end // else we're idle

		   // If we sent a command, record whether it was a read or write
		   if (cmdSend) nlastCmdWasWrite = command[41];
	 end
      end
   end
   always_ff @(posedge clk) begin
      if (rst) begin
		   lastCmdWasWrite <= 1;
      end else begin
		   lastCmdWasWrite <= nlastCmdWasWrite;
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
endmodule
