module clock_5mhz (
input  clk,  
input  rst,      
output reg clk_5mhz  
);
reg [3:0] counter = 0; 

always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_5mhz <= 0;
        end else if (counter == 9) begin
                counter <= 0;
                clk_5mhz <= ~clk_5mhz; 
          end else begin
            counter <= counter + 1;
        end
    end
endmodule