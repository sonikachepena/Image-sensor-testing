module reg_controller(
  input clk,
  input rst,
  input busy,
  input ack_err,
  input done,
  output reg start,
  output reg [7:0] device_addr,
  output reg [7:0] reg_addr,
  output reg [7:0] reg_data,
  output reg all_done
);

reg [4:0] index;
reg [3:0] state;
reg [17:0] delay_counter;

 parameter WAIT_2MS = 4'b0000;
 parameter   IDLE  = 4'b0001;
 parameter   LOAD  = 4'b0010;
 parameter   START = 4'b0011;
 parameter    WAIT  = 4'b0100;
 parameter   NEXT  = 4'b0101;
 parameter   DONE  = 4'b0110;

 
parameter REG_COUNT = 24;
 
always @(posedge clk or posedge rst) begin
    if (rst) begin
      index <= 0;
      state <= WAIT_2MS;
      delay_counter <= 0;
      start <= 0;
      device_addr <= 8'h00;
      reg_addr <= 8'h00;
      reg_data <= 8'h00;
      all_done <= 0;
    end else begin
      case (state)
      
         WAIT_2MS: begin
            if (delay_counter < 18'd200000) begin // 2ms @ 100 MHz
               delay_counter <= delay_counter + 1;
         end else begin
             delay_counter <= 0;
             state <= IDLE;
        end
      end
      
        IDLE: begin
          if (index <REG_COUNT) begin
            state <= LOAD;
          end else begin
            state <= DONE;
          end
        end
                                                                                                                                                                                                                                                                                                             
     LOAD: begin
         case(index)          
         
             0: begin device_addr <= 8'h6E; reg_addr <= 8'h40; reg_data <= 8'h00; end 
             1: begin device_addr <= 8'h6E; reg_addr <= 8'h40;  reg_data  <= 8'h00; end 
             2: begin device_addr <= 8'h6E; reg_addr<= 8'h30;  reg_data  <= 8'h30; end   //power_up sequence
             
             3: begin device_addr <= 8'h6E; reg_addr <= 8'h01; reg_data <= 8'h00; end    //additional start up sequence
             4: begin device_addr <= 8'h6E; reg_addr <= 8'h02;  reg_data  <= 8'h00; end 
             5: begin device_addr <= 8'h6E; reg_addr <= 8'h04;  reg_data  <= 8'hFF;end
             6: begin device_addr <= 8'h6E; reg_addr<= 8'h0A;  reg_data  <= 8'hFF; end  
             7: begin device_addr <= 8'h6E; reg_addr <= 8'h0B;  reg_data  <= 8'h07; end
             8: begin device_addr <= 8'h6E; reg_addr<= 8'h11;  reg_data  <= 8'h3C; end  
             9: begin device_addr <= 8'h6E; reg_addr <= 8'h1C;  reg_data  <= 8'h69; end 
             10: begin device_addr <= 8'h6E; reg_addr <= 8'h1D;  reg_data  <= 8'h00; end 
             11: begin device_addr <= 8'h6E; reg_addr <= 8'h1E;  reg_data  <= 8'h45; end 
             12: begin device_addr <= 8'h6E; reg_addr <= 8'h1F;  reg_data  <= 8'h05; end 
             13: begin device_addr <= 8'h6E; reg_addr <= 8'h30;  reg_data  <= 8'h30; end 
             14: begin device_addr <= 8'h6E; reg_addr <= 8'h31;  reg_data  <= 8'h73; end 
             15: begin device_addr <= 8'h6E; reg_addr <= 8'h32;  reg_data  <= 8'hAF; end 
             16: begin device_addr <= 8'h6E; reg_addr <= 8'h44;  reg_data  <= 8'hE0; end 
             17: begin device_addr <= 8'h6E; reg_addr  <= 8'h44;  reg_data  <= 8'hE0; end 
             
             18: begin device_addr <= 8'h6E; reg_addr<= 8'h08;  reg_data  <= 8'h01; end   
             19: begin device_addr <= 8'h6E; reg_addr <= 8'h09; reg_data <= 8'h00; end    
             20: begin device_addr <= 8'h6E; reg_addr<= 8'h0F;  reg_data  <= 8'hB2; end   
             21: begin device_addr <= 8'h6E; reg_addr <= 8'h10; reg_data <= 8'h00; end    
             
             22: begin device_addr <= 8'h6E; reg_addr<= 8'h00;  reg_data  <= 8'hC0; end    //CRO REG
         
             23: begin device_addr <= 8'h6E; reg_addr <= 8'h06; reg_data <= 8'h00; end    
            
         endcase
             state <= START; 
         end  
        
      START: begin
           if(!busy)begin
            start <= 1;
            state <= WAIT;
          end   
        end
        
        WAIT: begin
           start<=0;
          if (done)begin
            if(ack_err)
               state<=DONE;
            else 
            state <= NEXT;
           end
        end

        NEXT: begin
          index <= index + 1;
          state <= IDLE;
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
        DONE: begin
          all_done <= 1;
         // index <=1'b0;
          state <= DONE;
          
        end

        default: state <= IDLE;
      endcase
    end
  end
endmodule