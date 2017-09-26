
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module de0_cv(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	inout 		          		CLOCK4_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,
	input 		          		RESET_N,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// PS2 //////////
	inout 		          		PS2_CLK,
	inout 		          		PS2_CLK2,
	inout 		          		PS2_DAT,
	inout 		          		PS2_DAT2,

	//////////// microSD Card //////////
	output		          		SD_CLK,
	inout 		          		SD_CMD,
	inout 		     [3:0]		SD_DATA,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		     [3:0]		VGA_B,
	output		     [3:0]		VGA_G,
	output		          		VGA_HS,
	output		     [3:0]		VGA_R,
	output		          		VGA_VS,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_0,

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_1
);

//=======================================================
//  REG/WIRE declarations
//=======================================================

	//AHB-Lite
	wire                        HCLK;    
    wire                        HRESETn;
    wire  [ 31 : 0 ]            HADDR;      //  Address
    wire  [  2 : 0 ]            HBURST;     //  Burst Operation (0 -SINGLE, 2 -WRAP4)
    wire                        HSEL;       //  Chip select
    wire  [  2 : 0 ]            HSIZE;      //  Transfer Size (0 -x8,   1 -x16,     2 -x32)
    wire  [  1 : 0 ]            HTRANS;     //  Transfer Type (0 -IDLE, 2 -NONSEQ,  3-SEQ)
    wire  [ 31 : 0 ]            HWDATA;     //  Write data
    wire                        HWRITE;     //  Write request
    wire  [ 31 : 0 ]            HRDATA;     //  Read data
    wire                        HREADY;     //  Indicate the previous transfer is complete
    wire                        HRESP;      //  0 is OKAY, 1 is ERROR

	//debug
	wire  [ 31 : 0 ]            ERRCOUNT;   //err counter
    wire  [  7 : 0 ]            CHKCOUNT;   //check counter
    wire  [ 31 : 0 ]            STARTADDR;  //chech start addr


//=======================================================
//  Structural coding
//=======================================================

   wire clk200;

    pll pll(CLOCK_50, 1'b0 , DRAM_CLK, HCLK, clk200);

//	assign DRAM_CLK = CLOCK_50;
//	assign HCLK = CLOCK_50;

	assign HRESETn = KEY [0];
    assign STARTADDR = { { 20 { 1'b0 }}, SW, 2'b0 };

    assign LEDR[9] = ~DRAM_CKE;

	ahb_lite_rw_master
    #(
        .ADDR_INCREMENT ( 4         ),
        .DELAY_BITS     ( 26        ),
        .INCREMENT_CNT  ( 16000     ),
        .READ_ITER_CNT  ( 8000000   )
    )
    master 
    (
        .HCLK       (   HCLK        ),
        .HRESETn    (   HRESETn     ),
        .HADDR      (   HADDR       ),
        .HBURST     (   HBURST      ),
        .HSEL       (   HSEL        ),
        .HSIZE      (   HSIZE       ),
        .HTRANS     (   HTRANS      ),
        .HWDATA     (   HWDATA      ),
        .HWRITE     (   HWRITE      ),
        .HRDATA     (   HRDATA      ),
        .HREADY     (   HREADY      ),
        .HRESP      (   HRESP       ),

        .ERRCOUNT   (   ERRCOUNT    ),
        .CHKCOUNT   (   CHKCOUNT    ),
        .S_WRITE    (   LEDR[0]     ),
        .S_CHECK    (   LEDR[1]     ),
        .S_SUCCESS  (   LEDR[2]     ),
        .S_FAILED   (   LEDR[3]     ),
        .STARTADDR  (   STARTADDR   )
    );

	ahb_lite_sdram 
    #(
        //for T=20ns
        .DELAY_nCKE         (10000),
        .DELAY_tREF         (390),
        .DELAY_tRP          (0),
        .DELAY_tRFC         (2),
        .DELAY_tMRD         (0),
        .DELAY_tRCD         (0),
        .DELAY_tCAS         (1), //
        .DELAY_afterREAD    (0),
        .DELAY_afterWRITE   (2),
        .COUNT_initAutoRef  (8)
    ) 
    mem
    (
        .HCLK       (   HCLK        ),
        .HRESETn    (   HRESETn     ),
        .HADDR      (   HADDR       ),
        .HBURST     (   HBURST      ),
        .HSEL       (   HSEL        ),
        .HSIZE      (   HSIZE       ),
        .HTRANS     (   HTRANS      ),
        .HWDATA     (   HWDATA      ),
        .HWRITE     (   HWRITE      ),
        .HRDATA     (   HRDATA      ),
        .HREADY     (   1'b1        ),
        .HREADYOUT  (   HREADY      ),
        .HRESP      (   HRESP       ),

        .CKE        (   DRAM_CKE                ),
        .CSn        (   DRAM_CS_N               ),
        .RASn       (   DRAM_RAS_N              ),
        .CASn       (   DRAM_CAS_N              ),
        .WEn        (   DRAM_WE_N               ),
        .ADDR       (   DRAM_ADDR               ),
        .BA         (   DRAM_BA                 ),
        .DQ         (   DRAM_DQ                 ),
        .DQM        (   {DRAM_UDQM, DRAM_LDQM}  )
    );

	seven_segment digit_5 ( CHKCOUNT [ 7:4 ] , HEX5 [ 6:0] );
    seven_segment digit_4 ( CHKCOUNT [ 3:0 ] , HEX4 [ 6:0] );
    seven_segment digit_3 ( ERRCOUNT [15:12] , HEX3 [ 6:0] );
    seven_segment digit_2 ( ERRCOUNT [11:8 ] , HEX2 [ 6:0] );
    seven_segment digit_1 ( ERRCOUNT [ 7:4 ] , HEX1 [ 6:0] );
    seven_segment digit_0 ( ERRCOUNT [ 3:0 ] , HEX0 [ 6:0] );

endmodule