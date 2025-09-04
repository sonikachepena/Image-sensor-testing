module top_i2c_controller (
    input clk,
    input rst,
    inout sda,
    output scl,
    output all_done,
    output ack_err,
    // LVDS Inputs
    input clk_p,
    input clk_n,
    input data_p,
    input data_n,
    output clk_5mhz,
    output clk_div_out,
    output toggle_out,
    
   output [11:0] parallel_data_out
);

//wire clk_div_out;
    
    // Wires to connect controller and master
    wire start;
    wire ack_err_internal;
    wire busy;
    wire done;
    wire [7:0] device_addr;
    wire [7:0] reg_addr;
    wire [7:0] reg_data;
    
assign ack_err=ack_err_internal;

    // Instantiate the reg_controller
    reg_controller controller_inst (
        .clk(clk),
        .rst(rst),
        .busy(busy),
        .done(done),
        .start(start),
        .device_addr(device_addr),
        .reg_addr(reg_addr),
        .reg_data(reg_data),
        .all_done(all_done),
        .ack_err(ack_err_internal)
    );

    // Instantiate the master (I2C engine)
    master master_inst (
        .clk(clk),
        .rst(rst),
        .sda(sda),
        .scl(scl),
        .start(start),
        .device_addr(device_addr),
        .reg_addr(reg_addr),
        .reg_data(reg_data),
        .busy(busy),
        .ack_err(ack_err_internal),   
        .done(done)
    ); 
   
    clock_5mhz clock_inst(
    
      .clk(clk),
      .rst(rst),
      .clk_5mhz(clk_5mhz)
    );

wire [11:0] fdata_out_internal;

    iserdes_12bit_nobitslip lvds_inst (
        .clk_p(clk_p),
        .clk_n(clk_n),
        .data_p(data_p),
        .data_n(data_n),
        .rst(rst),
        .clk_div_out(clk_div_out),
        .fdata_out(fdata_out_internal)
    );
    
 assign parallel_data_out = fdata_out_internal;
 
 
 toggle_on_fff toggle_inst(
               .clk(clk_div_out),
               .rst(rst),
               .data_in( parallel_data_out),
               .toggle_out(toggle_out)
 );
 

ila_0 my_ila (
	.clk(clk), // input wire clk
	.probe0(parallel_data_out), // input wire [11:0]  probe0  
	.probe1(toggle_out) // input wire [0:0]  probe1
);

 
endmodule
