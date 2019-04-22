
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

// Controls:
// KEY[2]: reset the system.
// KEY[3]: Run the autofocus system.
// SW[9]: Choose between full and central auto-focus, plus yellow rectangle.

module DE1_SOC_D8M_RTL(

	//////////// ADC //////////
	output		          		ADC_CONVST, // ADC start CONVersion, Hauck's ADC module calls this ADC_CS_N (may or may not need to be inverted, I forgot)
	output		          		ADC_DIN,
	input 		          		ADC_DOUT,
	output		          		ADC_SCLK,

	//////////// Audio //////////
	input 		          		AUD_ADCDAT,
	input 		          		AUD_ADCLRCK,
	input 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	input 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR, // row/column address, depending on command specified by row/column strobes
	output		    [1:0]		DRAM_BA, // bank address. the SDRAM is split into 4 equal banks
	output		          		DRAM_CAS_N, // ColumnAddressStrobe, active-low
	output		          		DRAM_CKE, // ClocKEnable
	output		          		DRAM_CLK, // CLocK
	output		          		DRAM_CS_N, // ChipSelect, active-low
	inout 		    [15:0]		DRAM_DQ, // Data input/output port. Each data word is 16 bits = 2 bytes
	output		          		DRAM_LDQM, // Low DQ (data port) Mask, can be used to ignore the lower byte of the data port (DQ[7:0]) during a write operation
	output		          		DRAM_RAS_N, // RowAddressStrobe, active-low
	output		          		DRAM_UDQM, // Upper DQ Mask, same as LDQM, but for the upper byte (DQ[15:8]) instead of the lower one
	output		          		DRAM_WE_N, // WriteEnable, active-low

	//////////// I2C for Audio and Video-In //////////
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// IR //////////
	input 		          		IRDA_RXD,
	output		          		IRDA_TXD,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// PS2 //////////
	inout 		          		PS2_CLK,
	inout 		          		PS2_CLK2,
	inout 		          		PS2_DAT,
	inout 		          		PS2_DAT2,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// Video-In //////////
	input 		          		TD_CLK27,
	input 		     [7:0]		TD_DATA,
	input 		          		TD_HS,
	output		          		TD_RESET_N,
	input 		          		TD_VS,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,

	//////////// GPIO_1, GPIO_1 connect to D8M-GPIO //////////
	output 		          		CAMERA_I2C_SCL,
	inout 		          		CAMERA_I2C_SDA,
	output		          		CAMERA_PWDN_n,
	output		          		MIPI_CS_n,
	inout 		          		MIPI_I2C_SCL,
	inout 		          		MIPI_I2C_SDA,
	output		          		MIPI_MCLK,
	input 		          		MIPI_PIXEL_CLK,
	input 		     [9:0]		MIPI_PIXEL_D,
	input 		          		MIPI_PIXEL_HS,
	input 		          		MIPI_PIXEL_VS,
	output		          		MIPI_REFCLK,
	output		          		MIPI_RESET_n,
	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO 	
	
);

//=============================================================================
// Added code to insert Filter.sv into the output path
//=============================================================================
	// The signals from the system to the filter.
	wire		          		pre_VGA_BLANK_N;
	wire		     [7:0]		pre_VGA_B;
	wire		     [7:0]		pre_VGA_G;
	wire		          		pre_VGA_HS;
	wire		     [7:0]		pre_VGA_R;
	wire		          		pre_VGA_SYNC_N;
	wire		          		pre_VGA_VS;
	// The signals from the filter to the VGA
	wire		          		post_VGA_BLANK_N;
	wire		     [7:0]		post_VGA_B;
	wire		     [7:0]		post_VGA_G;
	wire		          		post_VGA_HS;
	wire		     [7:0]		post_VGA_R;
	wire		          		post_VGA_SYNC_N;
	wire		          		post_VGA_VS;
	
	Filter #(.WIDTH(640), .HEIGHT(480))
		filter (.VGA_CLK(VGA_CLK),
					.iVGA_B(pre_VGA_B), .iVGA_G(pre_VGA_G), .iVGA_R(pre_VGA_R),
					.iVGA_HS(pre_VGA_HS), .iVGA_VS(pre_VGA_VS),
					.iVGA_SYNC_N(pre_VGA_SYNC_N), .iVGA_BLANK_N(pre_VGA_BLANK_N),
					.oVGA_B(post_VGA_B), .oVGA_G(post_VGA_G), .oVGA_R(post_VGA_R),
					.oVGA_HS(post_VGA_HS), .oVGA_VS(post_VGA_VS),
					.oVGA_SYNC_N(post_VGA_SYNC_N), .oVGA_BLANK_N(post_VGA_BLANK_N),
					.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
					.LEDR(), .KEY(KEY[1:0]), .SW(SW[8:0])); // TODO RECONNECT LEDR
					
	assign VGA_BLANK_N = post_VGA_BLANK_N;
	assign VGA_B = post_VGA_B;
	assign VGA_G = post_VGA_G;
	assign VGA_HS = post_VGA_HS;
	assign VGA_R = post_VGA_R;
	assign VGA_SYNC_N = post_VGA_SYNC_N;
	assign VGA_VS = post_VGA_VS;

//=============================================================================
// REG/WIRE declarations
//=============================================================================


wire	[15:0]SDRAM_RD_DATA;
wire			DLY_RST_0;
wire			DLY_RST_1;
wire			DLY_RST_2;

wire			SDRAM_CTRL_CLK;
wire        D8M_CK_HZ ; 
wire        D8M_CK_HZ2 ; 
wire        D8M_CK_HZ3 ; 

wire [7:0] RED   ; 
wire [7:0] GREEN  ; 
wire [7:0] BLUE 		 ; 
wire [12:0] VGA_H_CNT;			
wire [12:0] VGA_V_CNT;	

wire        READ_Request ;
wire 	[7:0] B_AUTO;
wire 	[7:0] G_AUTO;
wire 	[7:0] R_AUTO;
wire        RESET_N  ; 

wire        I2C_RELEASE ;  
wire        AUTO_FOC ; 
wire        CAMERA_I2C_SCL_MIPI ; 
wire        CAMERA_I2C_SCL_AF;
wire        CAMERA_MIPI_RELAESE ;
wire        MIPI_BRIDGE_RELEASE ;  
 
wire        LUT_MIPI_PIXEL_HS;
wire        LUT_MIPI_PIXEL_VS;
wire [9:0]  LUT_MIPI_PIXEL_D  ;
wire        MIPI_PIXEL_CLK_; 
wire [9:0]  PCK;

logic clk125; // 125 MHz clock for SDRAM
logic [12:0] VGA_x, VGA_y; // x and y of the current VGA pixel   
//=======================================================
// Structural coding
//=======================================================
//--INPU MIPI-PIXEL-CLOCK DELAY
// Combinationally delay this clock to pass hold timing requirements. It may not look necessary, but your design will not work without it.
CLOCK_DELAY  del1(  .iCLK (MIPI_PIXEL_CLK),  .oCLK (MIPI_PIXEL_CLK_ ) );


assign LUT_MIPI_PIXEL_HS=MIPI_PIXEL_HS;
assign LUT_MIPI_PIXEL_VS=MIPI_PIXEL_VS;
assign LUT_MIPI_PIXEL_D =MIPI_PIXEL_D ;

//------UART OFF --
//assign UART_RTS =0; 
//assign UART_TXD =0; 
//------HEX OFF --
//assign HEX2           = 7'h7F;
//assign HEX3           = 7'h7F;
//assign HEX4           = 7'h7F;
//assign HEX5           = 7'h7F;

//------ MIPI BRIGE & CAMERA RESET  --
assign CAMERA_PWDN_n  = 1; 
assign MIPI_CS_n      = 0; 
assign MIPI_RESET_n   = RESET_N ;

//------ CAMERA MODULE I2C SWITCH  --
assign I2C_RELEASE    = CAMERA_MIPI_RELAESE & MIPI_BRIDGE_RELEASE; 
assign CAMERA_I2C_SCL =( I2C_RELEASE  )?  CAMERA_I2C_SCL_AF  : CAMERA_I2C_SCL_MIPI ;   

//------ CLOCK GENERATOR --
// Supposedly has auto self-reset, but it never gets a lock
// Create a reset signal that's true for one clock cycle after the FPGA boots and stays off forever afterwards
//logic PLL_BootReset = 1;
//always_ff @(posedge CLOCK_50) PLL_BootReset <= 0;
PLL_GenClocks clockGenerator (
      .refclk(CLOCK_50), .rst(0), // Configured the PLL to have an automatic self-reset
      .outclk_0(),//MIPI_REFCLK), // MIPI / VGA REF CLOCK, 20 MHz
      .outclk_1(VGA_CLK), // MIPI / VGA REF CLOCK, 25 MHz
      .outclk_2(clk125), // SDRAM controller clock, 125 MHz
      .locked(LEDR0) // true if the PLL has acquired (locked onto) the reference clock
   );
//------MIPI / VGA REF CLOCK  --
pll_test pll_ref(
	                   .inclk0 ( CLOCK3_50 ),
	                   .areset ( ~KEY[2]   ),
	                   .c0( MIPI_REFCLK    ) //20Mhz
    );
    
//----- RESET RELAY  --		
RESET_DELAY u2 (	
      .iRST  ( KEY[2] ),
      .iCLK  ( CLOCK2_50 ),
      .oRST_0( DLY_RST_0 ),
      .oRST_1( DLY_RST_1 ),
      .oRST_2( DLY_RST_2 ),					
      .oREADY( RESET_N)  
   );
 
//------ MIPI BRIGE & CAMERA SETTING  --  
MIPI_BRIDGE_CAMERA_Config    cfin(
                      .RESET_N           ( RESET_N ),
                      .CLK_50            ( CLOCK2_50 ), 
                      .MIPI_I2C_SCL      ( MIPI_I2C_SCL ), 
                      .MIPI_I2C_SDA      ( MIPI_I2C_SDA ), 
                      .MIPI_I2C_RELEASE  ( MIPI_BRIDGE_RELEASE ),  
                      .CAMERA_I2C_SCL    ( CAMERA_I2C_SCL_MIPI ),
                      .CAMERA_I2C_SDA    ( CAMERA_I2C_SDA ),
                      .CAMERA_I2C_RELAESE( CAMERA_MIPI_RELAESE )
             );
				 
//------ CAMERA COORDINATE TRACKER --
   // Determine current camera pixel coordinates
   logic cameraPixelIsValid;
	assign LEDR[8] = cameraPixelIsValid; // TODO DELETE
	assign LEDR[7:6] = 2'd1;
   logic [18:0] cameraPixelAddress;
   CameraCoordTracker camTracker (
				  .clk(MIPI_PIXEL_CLK_), .arst(~DLY_RST_0),
				  .hsync_n(LUT_MIPI_PIXEL_HS), .vsync_n(LUT_MIPI_PIXEL_VS),
				  .pixelValid(cameraPixelIsValid),
				  .pixelAddress(cameraPixelAddress), .x(), .y()
				  );

//------ SDRAM CONTROLLER AND PORT WRAPPER --
   // Instantiates the SDRAM inside a wrapper that multiplexes multiple ports at lower speeds into the SDRAM's single port at high speed
   logic 	srstSlow, srst, srstMS0, srstMS1;
   logic [26:0] srstCtr = 27'd0; // overflows @ 1.07 Hz (counting @ 125 MHz)
   always_ff @(posedge clk125) begin
      {srst, srstMS1, srstMS0} <= {srstMS1, srstMS0, ~KEY[2]};
      srstCtr <= srstCtr + 27'd0;
      if (srstCtr == 0) srstSlow <= srst;
   end
   SDRAM_Ports sdramPorts (
			   .clk(clk125), .rst(srstSlow),
			   // Port C: camera write port
			   .portC_clk(MIPI_PIXEL_CLK_),
			   .portC_aclr(~DLY_RST_0),
			   .portC_write(cameraPixelIsValid),
			   .portC_addr({6'd0, cameraPixelAddress}),
			   .portC_din(MIPI_PIXEL_D),

			   // Port V: VGA read port
			   .portV_clk(VGA_CLK),
			   // Automatic read requesting
			   .portV_arst(~DLY_RST_1), // auto read requester async reset
			   .portV_readOffset(25'd0),
			   .portV_VGAx(VGA_x[9:0]), // VGA x,y for deciding what pixel value to ask the SDRAM for
			   .portV_VGAy(VGA_y[9:0]), // TODO: fix VGA_Controller signal widths
			   .portV_nextDout(READ_Request),
			   .portV_dout(SDRAM_RD_DATA), // only [9:0] is actually used

			   // General-purpose read-write port for you to use
			   .port0_clk0(), // clock for sending read/write commands to Port0
			   .port0_aclr0(1'b0), // asynchronous clear for Port0 command FIFO
			   .port0_addr(), // 25-bit
			   .port0_wrreq(), // request a write to the specified address
			   .port0_din(), // data to write, 16-bit
			   .port0_rdreq(), // request a read from the specified address
			   .port0_full(), // true/1'b1 if Port0 cannot accept new commands yet
			   // Port0 readout FIFO (standard, NOT FWFT)
			   .port0_clk1(), // clock for retreiving read data from Port0 (you'll probably just connect this to the same clock as port0_clk0)
			   .port0_aclr1(1'b0), // asynchronous clear for Port0 readout FIFO
			   .port0_empty(), // true/1'b1 if no new read data
			   .port0_read(), // get a new readout from port0_dout
			   .port0_dout(), // read data output in the format {25'address, 16'data}

			   // Add your own custom ports, or share Port0


			   // SDRAM connections
			   .DRAM_DQ, .DRAM_ADDR, .DRAM_BA, .DRAM_CAS_N, .DRAM_CKE,
			   .DRAM_CLK, .DRAM_CS_N, .DRAM_LDQM, .DRAM_RAS_N, .DRAM_UDQM, .DRAM_WE_N
			   );
   

   // Create a reset signal that's true for one clock cycle after the FPGA boots and stays off forever afterwards
   //logic SDRAM_ControllerReset = 1;
   //always_ff @(posedge clk125) SDRAM_ControllerReset <= 0;
   
	 
//------ CMOS CCD_DATA TO RGB_DATA -- 

RAW2RGB_J u4 (	
		.RST( pre_VGA_VS ),
		.iDATA( SDRAM_RD_DATA[9:0] ),
		
		//-----------------------------------
                .VGA_CLK      ( VGA_CLK ),
                .READ_Request ( READ_Request ),
                .VGA_VS       ( pre_VGA_VS ),	
		.VGA_HS       ( pre_VGA_HS ), 
	                  			
		.oRed         ( RED  ),
		.oGreen       ( GREEN),
		.oBlue        ( BLUE )
);
			   
//------AOTO FOCUS ENABLE  --
AUTO_FOCUS_ON vd ( 
                   .CLK_50      ( CLOCK2_50 ), 
                   .I2C_RELEASE ( I2C_RELEASE ), 
                   .AUTO_FOC    ( AUTO_FOC )
);				

//------AOTO FOCUS ADJ  --
FOCUS_ADJ adl(
              .CLK_50        ( CLOCK2_50 ) , 
              .RESET_N       ( I2C_RELEASE ), 
              .RESET_SUB_N   ( I2C_RELEASE ), 
              .AUTO_FOC      ( KEY[3] & AUTO_FOC ), 
              .SW_Y          ( 0 ),
              .SW_H_FREQ     ( 0 ),   
              .SW_FUC_LINE   ( SW[9] ),   
              .SW_FUC_ALL_CEN( SW[9] ),
              .VIDEO_HS      ( pre_VGA_HS ),
              .VIDEO_VS      ( pre_VGA_VS ),
              .VIDEO_CLK     ( VGA_CLK ),
	      .VIDEO_DE      (READ_Request) ,
              .iR            ( R_AUTO ), 
              .iG            ( G_AUTO ), 
              .iB            ( B_AUTO ), 
              .oR            ( pre_VGA_R ) , 
              .oG            ( pre_VGA_G ) , 
              .oB            ( pre_VGA_B ) , 
              
              .READY         (LEDR[9]), // ( READY ),// TODO DISCONNECT
              .SCL           ( CAMERA_I2C_SCL_AF ), 
              .SDA           ( CAMERA_I2C_SDA )
);

//------VGA Controller  --
VGA_Controller u1 ( // Host Side
		    .oRequest( READ_Request ),
		    .iRed    ( RED    ),
		    .iGreen  ( GREEN  ),
		    .iBlue   ( BLUE   ),
		    
		    //	VGA Side
		    .oVGA_R  ( R_AUTO[7:0] ),
		    .oVGA_G  ( G_AUTO[7:0] ),
		    .oVGA_B  ( B_AUTO[7:0] ),
		    .oVGA_H_SYNC( pre_VGA_HS ),
		    .oVGA_V_SYNC( pre_VGA_VS ),
		    .oVGA_SYNC  ( pre_VGA_SYNC_N ),
		    .oVGA_BLANK ( pre_VGA_BLANK_N ),
		    //	Control Signal
		    .iCLK       ( VGA_CLK ),
		    .iRST_N     ( DLY_RST_2 ),
		    .H_Cont     ( VGA_H_CNT ),
		    .V_Cont     ( VGA_V_CNT ),
		    .x(VGA_x),
		    .y(VGA_y)
);

//------VS FREQUENCY TEST = 60HZ --
							
//FpsMonitor uFps( 
//	   .clk50    ( CLOCK2_50 ),
//	   .vs       ( LUT_MIPI_PIXEL_VS ),
//	
//	   .fps      (),
//	   .hex_fps_h( HEX1 ),
//	   .hex_fps_l( HEX0 )
//);


//--LED DISPLAY--
CLOCKMEM  ck1 ( .CLK(VGA_CLK )   ,.CLK_FREQ  (25000000  ) , . CK_1HZ (D8M_CK_HZ   )  )        ;//25MHZ
CLOCKMEM  ck2 ( .CLK(MIPI_REFCLK   )   ,.CLK_FREQ  (20000000   ) , . CK_1HZ (D8M_CK_HZ2  )  ) ;//20MHZ
CLOCKMEM  ck3 ( .CLK(MIPI_PIXEL_CLK_)   ,.CLK_FREQ  (25000000  ) , . CK_1HZ (D8M_CK_HZ3  )  )  ;//25MHZ


//assign LEDR = { D8M_CK_HZ ,D8M_CK_HZ2,D8M_CK_HZ3 ,5'h0,CAMERA_MIPI_RELAESE ,MIPI_BRIDGE_RELEASE  } ; 

endmodule
