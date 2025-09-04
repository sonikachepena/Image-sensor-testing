module toggle_on_fff (
    input  wire        clk,         // Clock input
    input  wire        rst,         // Active-high reset
    input  wire [11:0] data_in,     // 12-bit input data (e.g., fdata_out)
    output reg         toggle_out   // Output toggle signal
);


parameter IDLE  = 2'b00;
parameter SEEN_FFF = 2'b01;
parameter SEEN_000_FIRST = 2'b10;
//parameter SEEN_000_SECOND = 2'b11;

reg [1:0] state;

always @(posedge clk or posedge rst) begin
        if (rst) begin
            state      <= IDLE;
            toggle_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in == 12'hFFF)
                       state <= SEEN_FFF;
                end

                SEEN_FFF: begin
                    if (data_in == 12'h000)
                        state <= SEEN_000_FIRST;
                    else
                        state <= IDLE;
                end
               SEEN_000_FIRST: begin
                    if (data_in == 12'h000)begin
                        toggle_out <= ~toggle_out; // Sequence complete
                        state <=IDLE; // Reset to start detection again
                  end  else
                        state <= IDLE;
                end
            endcase
        end
    end

endmodule


/*reg [11:0] prev_data;
    always @(posedge clk or posedge rst) begin
        if (rst)begin
            toggle_out <= 1'b0;
            prev_data  <= 12'd0;
       end else begin 
            if (prev_data == 12'hFFF && data_in == 12'h000)
                 toggle_out <= ~toggle_out;  // Toggle on 0xFFF
            prev_data <= data_in;
    end
end*/
