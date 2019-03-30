
// Keeps track of what pixel the current camera data corresponds to.
// Gives 2 different formats of the current pixel coordinate: pixelAddress and (x, y)
module CameraCoordTracker (
         input logic clk, arst, hsync_n, vsync_n, // syncs are active-low

         output logic pixelValid, // indicates when MIPI_PIXEL_D is valid
         output logic [18:0] pixelAddress, // 2^19 > 640*480, cameraX = camctr % 640, cameraY = camctr / 640
         output logic [9:0] x, y // 2^10 > 640
      );
   // pixel invalid during horizontal or vertical sync
   assign pixelValid = hsync & vsync;

   logic endFrame;
   assign endFrame = (pixelAddress == 307199);
   
   always_ff @(posedge clk or posedge arst) begin
      if (arst) begin
	 {pixelAddress, x, y} <= '0;
      end else begin
	 if (enable) begin
	    // pixelAddress = (pixelAddress + 1) % (640*480)
	    pixelAddress <= endFrame ? 19'd0 : (pixelAddress + 19'd1);
	    // x = (x + 1) % 640
	    if (x == 10'd639) begin
	       x <= 10'd0;
	       // y = (y + 1) % 480
	       y <= endFrame ? 10'd0 : (y + 10'd1);
	    end else begin
	       x <= x + 10'd1;
	       y <= y;
	    end
	 end else begin // !enable
	    pixelAddress <= pixelAddress;
	    {x, y} <= {x, y};
	 end
      end
   end
endmodule
