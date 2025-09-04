module iserdes_12bit_nobitslip (
    input  wire clk_p,     
    input  wire clk_n,
    input  wire data_p,
    input  wire data_n,
    input  wire rst,
    output wire clk_div_out,
    output reg [11:0] fdata_out
);

 
 wire clk_out;
 wire clk_out180;
 wire data_out_p, data_out_n;
 wire locked;
    
  
  wire clk_buf;
  // Using built-in FPGA primitives
    IBUFDS #(
        .DIFF_TERM("FALSE"),  
        .IOSTANDARD("LVDS") 
    ) ibuf_clk (
        .I(clk_p), 
        .IB(clk_n), 
        .O(clk_buf)
    );


  clk_wiz_0  clk_wiz_gen
   (
    // Clock out ports
    .clk_out30_0mhz(clk_out),     // output clk_out30_0mhz
    .clk_out5mhz(clk_div_out),     // output clk_out5mhz
    .clk_out30_180mhz(clk_out180),     // output clk_out30_180mhz
    // Status and control signals
    .reset(1'b0), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk_buf)      // input clk_in1
);




// DIFFERENTIAL DATA TO SINGLE ENEDD CONVERTION 
    IBUFDS_DIFF_OUT #(
        .DIFF_TERM("FALSE"),
        .IOSTANDARD("LVDS")   
    ) IBUFDS_DIFF_OUT_data (
        .I(data_p),  
        .IB(data_n),
        .OB(data_out_n), 
        .O(data_out_p)  
    );
    

// DATA TO STORE WIRES
wire [5:0] data_a, data_b;

//THIS IS A MODULE CONFIGURATION
ISERDESE2 #(
        .DATA_RATE("SDR"),
        .DATA_WIDTH(6),
        .DYN_CLKDIV_INV_EN("FALSE"), 
        .DYN_CLK_INV_EN("FALSE"),  
        .INIT_Q1(1'b0),
        .INIT_Q2(1'b0),
        .INIT_Q3(1'b0),
        .INIT_Q4(1'b0), 
        .SRVAL_Q1(1'b0),
        .SRVAL_Q2(1'b0),
        .SRVAL_Q3(1'b0),
        .SRVAL_Q4(1'b0),
        .IOBDELAY("NONE"),
        .NUM_CE(2),
        .OFB_USED("FALSE"), 
        .INTERFACE_TYPE("NETWORKING"),
        .SERDES_MODE("MASTER")
    )iserdes_inst (
       .Q1(data_a[0]),
       .Q2(data_a[1]),
       .Q3(data_a[2]),
       .Q4(data_a[3]),
       .Q5(data_a[4]),
       .Q6(data_a[5]),
        .Q7(),
        .Q8(),
        .BITSLIP(1'b0),    
        .CE1(1'b1),
        .CE2(1'b1),
        .CLK(clk_out),        
        .CLKB(clk_out180),     
        .CLKDIV(clk_div_out),        
        .D(data_out_p),
        .DDLY(),                 // 1-bit input: Serial data from IDELAYE2
        .OFB(1'b0),   
        .O(),
        .OCLK(1'b0),
        .OCLKB(1'b0),
        .DYNCLKDIVSEL(1'b0),
        .DYNCLKSEL(1'b0),
        .RST(~locked),
       .SHIFTIN1(),
       .SHIFTIN2(),
       .SHIFTOUT1(),
       .SHIFTOUT2()
    );
    
 // THIS IS B MODULE CONFIGURATION
    ISERDESE2 #(
        .DATA_RATE("SDR"),
        .DATA_WIDTH(6),
        .DYN_CLKDIV_INV_EN("FALSE"), 
        .INIT_Q1(1'b0),
        .INIT_Q2(1'b0),
        .INIT_Q3(1'b0),
        .INIT_Q4(1'b0),
        .SRVAL_Q1(1'b0),
        .SRVAL_Q2(1'b0),
        .SRVAL_Q3(1'b0),
        .SRVAL_Q4(1'b0),
        .DYN_CLK_INV_EN("FALSE"), 
        .OFB_USED("FALSE"),  
        .IOBDELAY("NONE"), 
        .NUM_CE(2),
        .INTERFACE_TYPE("NETWORKING"),
        .SERDES_MODE("MASTER")
    )iserdes_insts (
        .Q1(data_b[0]),   
        .Q2(data_b[1]),
        .Q3(data_b[2]), 
        .Q4(data_b[3]),
        .Q5(data_b[4]), 
        .Q6(data_b[5]),
        .Q7(),
        .Q8(),
        
        .BITSLIP(1'b0),  
        .CE1(1'b1),
        .CE2(1'b1),  
        .CLK(clk_out180),         
        .CLKB(clk_out),     
        .CLKDIV(clk_div_out),        
        .D(data_out_n),    
        .DDLY(),                 // 1-bit input: Serial data from IDELAYE2
        .OFB(1'b0),     
        .O(),
        .OCLK(1'b0),
        .OCLKB(1'b0),
        .DYNCLKDIVSEL(1'b0),
        .DYNCLKSEL(1'b0),
        .RST(~locked),
       .SHIFTIN1(),
       .SHIFTIN2(),
       .SHIFTOUT1(),
       .SHIFTOUT2()   
    );
    


always @(posedge clk_div_out  or posedge rst) begin
        if (rst)
            fdata_out <= 12'd0;
       else 
       /* fdata_out[11] <= data_a[5];
        fdata_out[10] <= ~data_b[5];
        fdata_out[9]  <= data_a[4];
        fdata_out[8]  <= ~data_b[4];
        fdata_out[7]  <= data_a[3];
        fdata_out[6]  <= ~data_b[3];
        fdata_out[5]  <= data_a[2];
        fdata_out[4]  <= ~data_b[2];
        fdata_out[3]  <= data_a[1];
        fdata_out[2]  <= ~data_b[1];
        fdata_out[1]  <= data_a[0];
        fdata_out[0]  <= ~data_b[0];*/ 
        fdata_out={data_a[5],~data_b[5],data_a[4],~data_b[4], data_a[3],~data_b[3],data_a[2],~data_b[2],data_a[1],~data_b[1],data_a[0],~data_b[0]};

 end
 
endmodule



/*    
wire refclk_200m;
wire locked1;

clk_wiz_1 clk_wiz1_gen
   (
    // Clock out ports
    .clk_out1(refclk_200m),     // output clk_out1
    // Status and control signals
    .reset(1'b0), // input reset
    .locked(locked1),       // output locked
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
);

(* IODELAY_GROUP = "IODELAY_GRP1" *)
 IDELAYCTRL idelayctrl_inst (
  .RDY(),          
  .REFCLK(refclk_200m), // must be a global 200 MHz clock
  .RST(rst)     
);


wire delayed_data;

(* IODELAY_GROUP = "IODELAY_GRP1" *)
IDELAYE2 #(
   .CINVCTRL_SEL("FALSE"),     
   .DELAY_SRC("IDATAIN"),     
   .HIGH_PERFORMANCE_MODE("FALSE"),
   .IDELAY_TYPE("FIXED"),       
   .IDELAY_VALUE(0),              
   .PIPE_SEL("FALSE"),            
   .REFCLK_FREQUENCY(200.0),      
   .SIGNAL_PATTERN("DATA")        
)    
IDELAYE2_inst (
   .CNTVALUEOUT(), 
   .DATAOUT(delayed_data),         
   .C(clk_div_out),                
   .CE(1'b0),                  
   .CINVCTRL(1'b0),  
   .CNTVALUEIN(1'b0),
   .DATAIN(1'b0),           
   .IDATAIN(data_out), //doubt      
   .INC(1'b0),                
   .LD(1'b0),              
   .LDPIPEEN(1'b0),      
   .REGRST(1'b0)         
);*/



