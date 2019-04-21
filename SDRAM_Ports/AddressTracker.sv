
`timescale 1 ns / 1 ps

module AddressTracker (
		       input logic 	   clk, portV_arst, readValid,
		       input logic [24:0]  raddr, readOffset,
		       input logic [8:0]   PortVout_usedw,
		       output logic 	   PortVout_wrreq, PortVout_nullData
		       );
   // Write the correct rdata to the PortV output FIFO and prevent it from becoming empty with dummy data when necessary
   logic [18:0] VGA_addrTracker, nextVGA_addrTracker;
   logic addrMatches;
   always_comb begin
      addrMatches = (raddr == ({6'd0, VGA_addrTracker} + readOffset));
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
endmodule

module AddressTracker_tb ();
   logic clk, portV_arst, readValid, PortVout_wrreq, PortVout_nullData;
   logic [24:0] raddr, readOffset, addr;
   logic [8:0] 	PortVout_usedw;

   AddressTracker dut (.*);

   initial begin
      clk = 0;
      forever #8 clk = ~clk; // 125 MHz
   end

   // FIFO emulator
   logic [1:0] ctr; // "read" a value every 4 clocks
   always_ff @(posedge clk, posedge portV_arst) begin
      if (portV_arst) begin
	 {PortVout_usedw, ctr} <= '0;
      end else begin
	 ctr <= ctr + 2'd1;
	 if ((ctr == 2'd0) & (PortVout_usedw != 0)) begin
	    if (~PortVout_wrreq) PortVout_usedw <= PortVout_usedw - 9'd1;
	 end else if (PortVout_wrreq) begin
	    PortVout_usedw <= PortVout_usedw + 9'd1;
	 end
      end
   end // always_ff @ (posedge clk, posedge portV_arst)

   // Set raddr to random garbage while readValid isn't true
   logic [24:0] randGarbo;
   always_ff @(posedge clk) begin
      randGarbo <= $urandom_range(0, 2**25 - 1);
   end
   always_comb begin
      if (readValid) raddr = addr;
      else raddr = randGarbo;
   end

   int i;
   initial begin
      {portV_arst, readValid, addr, readOffset} = '0;
      @(negedge clk);
      #2;
      portV_arst = 1;
      #3;
      portV_arst = 0;

      assert(PortVout_wrreq);
      @(negedge clk);
      assert(PortVout_wrreq);
      @(negedge clk);
      assert(PortVout_usedw == 9'd2);

      repeat (7) @(negedge clk);

      // Check that it prefers real data over null data
      assert(PortVout_usedw == 9'd1);
      readValid = 1;
      addr = 25'd3;
      #1;
      assert({PortVout_wrreq, PortVout_nullData} == 2'b10); // writing real data
      @(negedge clk);

      for (i = 0; i < 5; i++) begin
	 readValid = 1;
	 addr = 25'd4 + i[24:0];
	 #1;
	 assert({PortVout_wrreq, PortVout_nullData} == 2'b10); // writing real data
	 @(negedge clk);
      end

      readValid = 0;
      while (PortVout_usedw != 9'd1) begin
	 assert({PortVout_wrreq, PortVout_nullData} == 2'b00); // not writing
	 @(negedge clk);
      end

      assert({PortVout_wrreq, PortVout_nullData} == 2'b11); // writing null data
      @(negedge clk);

      readValid = 1;
      repeat (10) begin
	 addr = randGarbo;
	 if (PortVout_wrreq) assert(PortVout_nullData); // writing null data
	 @(negedge clk);
      end
      
      readValid = 0;
      repeat (10) @(negedge clk);

      $stop;
   end
endmodule // AddressTracker_tb
