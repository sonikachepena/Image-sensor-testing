 module master(
  input clk,
  input rst,
  inout sda,   
  output scl,  
  input start,
  input [7:0] device_addr,
  input [7:0] reg_addr,  
  input [7:0] reg_data,
  output reg busy,ack_err,done
); 
  
       
  reg scl_t = 0;
  reg sda_t = 0;
 
  parameter sys_freq = 100000000;  
  parameter i2c_freq = 100000;  
  parameter clk_count4 = (sys_freq / i2c_freq);
  parameter clk_count1 = clk_count4 / 4;   
  integer count1 = 0;
  
  reg [1:0] pulse = 0;
  
 
  always @(posedge clk) begin
    if (rst) begin
      pulse <= 0;
      count1 <= 0;
    end else if (busy == 1'b0) begin
      pulse <= 0;
      count1 <= 0;
    end else if (count1 == clk_count1 - 1) begin
      pulse <= 1;
      count1 <= count1 + 1;
    end else if (count1 == clk_count1 * 2 - 1) begin
      pulse <= 2;
      count1 <= count1 + 1;
    end else if (count1 == clk_count1 * 3 - 1) begin
      pulse <= 3;
      count1 <= count1 + 1;
    end else if (count1 == clk_count1 * 4 - 1) begin
      pulse <= 0;
      count1 <= 0;
    end else begin
      count1 <= count1 + 1;
    end
  end

  reg [3:0] state;
  reg [3:0] bitcount = 0;
  reg r_ack = 0;
  reg sda_en = 0;

  
  parameter IDLE = 4'b0000;
  parameter START = 4'b0001;
  parameter DEVICE_ADDR = 4'b0010;
  parameter ACK_1 = 4'b0011;
  parameter REG_ADDR =4'b0100;
  parameter ACK_2 =4'b0101;
  parameter REG_DATA =4'b0110;
  parameter ACK_3 =4'b0111;
  parameter STOP = 4'b1000;
  
  
  
  always @(posedge clk) begin
    if (rst) begin
      bitcount <= 0;
      scl_t <= 1;
      sda_t <= 1;
      state <= IDLE;
      busy <= 1'b0;
      done <= 1'b0;
      ack_err <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
         done <= 1'b0;
         sda_en <= 1'b0;
         ack_err <= 1'b0;
         busy<=1'b0;
        if (start) begin
          busy <= 1'b1;
          ack_err <= 1'b0;
          state <= START;
       end else begin
           state <= IDLE;
         
      end
     end

        START: begin
          sda_en <= 1'b1;
          case (pulse)
            0: begin scl_t <= 1'b1; sda_t <= 1'b1; end
            1: begin scl_t <= 1'b1; sda_t <= 1'b1; end
            2: begin scl_t <= 1'b1; sda_t <= 1'b0; end
            3: begin scl_t <= 1'b1; sda_t <= 1'b0; end
          endcase
          if (count1 == clk_count1 * 4 - 1) begin
            state <= DEVICE_ADDR;
            scl_t <= 1'b0;
          end else begin
            state <= START;
          end
        end

        DEVICE_ADDR: begin
          sda_en <= 1'b1;
          if (bitcount <= 7) begin
            case (pulse)
              0: begin scl_t <= 1'b0; end
              1: begin scl_t <= 1'b0; sda_t <= device_addr[7 - bitcount]; end
              2: begin scl_t <= 1'b1; end
              3: begin scl_t <= 1'b1; end
            endcase
            if (count1 == clk_count1 * 4 - 1) begin
              state <= DEVICE_ADDR;
              scl_t <= 1'b0;
              bitcount <= bitcount + 1;
            end else begin
              state <= DEVICE_ADDR;
            end
          end else begin
            state <= ACK_1;
            bitcount <= 0;
            sda_en <= 1'b0;
          end
        end
        ACK_1: begin
          sda_en <= 1'b0;
          case (pulse)
            0: begin scl_t <= 1'b0;  end
            1: begin scl_t <= 1'b0;  end
            2: begin scl_t <= 1'b1; r_ack <=sda; end
            3: begin scl_t <= 1'b1; end
          endcase
          if (count1 == clk_count1 * 4 - 1) begin
            if (r_ack == 1'b0) begin 
              ack_err <= 1'b0;
              sda_en<=1'b1;
              sda_t <= 1'b0;
              bitcount<=0;
              state <= REG_ADDR; 
            end else begin
              ack_err <= 1'b1; 
              sda_en<=1'b1;
              state <=STOP;
            end
             
          end else begin
            state <= ACK_1;
          end
        end
        
        
        REG_ADDR: begin
          sda_en <= 1'b1;
          if (bitcount <= 7) begin
            case (pulse)
              0: begin scl_t <= 1'b0; end
              1: begin scl_t <= 1'b0; sda_t <= reg_addr[7 - bitcount]; end
              2: begin scl_t <= 1'b1; end
              3: begin scl_t <= 1'b1; end
            endcase
            if (count1 == clk_count1 * 4 - 1) begin
              state <= REG_ADDR;
              scl_t <= 1'b0;
              bitcount <= bitcount + 1;
            end else begin
              state <= REG_ADDR;
            end
          end else begin
            state <= ACK_2;
            bitcount <= 0;
            sda_en <= 1'b0;
          end
        end
        ACK_2: begin
          sda_en <= 1'b0;
          case (pulse)
            0: begin scl_t <= 1'b0;  end
            1: begin scl_t <= 1'b0;  end
            2: begin scl_t <= 1'b1; r_ack <=sda; end
            3: begin scl_t <= 1'b1; end
          endcase
          if (count1 == clk_count1 * 4 - 1) begin
            if (r_ack == 1'b0) begin 
              ack_err <= 1'b0;
              sda_en<=1'b1;
              sda_t <= 1'b0;
              bitcount<=0;
              state <= REG_DATA; 
            end else begin
              ack_err <= 1'b1; 
              sda_en<=1'b1;
              state <= STOP;
            end
             
          end else begin
            state <= ACK_2;
          end
        end
        
      
        REG_DATA: begin
          sda_en <= 1'b1;
          if (bitcount <= 7) begin
            case (pulse)
              0: begin scl_t <= 1'b0; end
              1: begin scl_t <= 1'b0; sda_t <= reg_data[7 - bitcount]; end
              2: begin scl_t <= 1'b1; end
              3: begin scl_t <= 1'b1; end
            endcase
            if (count1 == clk_count1 * 4 - 1) begin
              state <= REG_DATA;
              scl_t <= 1'b0;
              bitcount <= bitcount + 1;
            end else begin
              state <= REG_DATA;
            end
          end else begin
            state <= ACK_3;
            bitcount <= 0;
            sda_en <= 1'b0;
          end
        end
        
        ACK_3: begin
          sda_en <= 1'b0;
          case (pulse)
            0: begin scl_t <= 1'b0;  end
            1: begin scl_t <= 1'b0;  end
            2: begin scl_t <= 1'b1; r_ack <=sda; end
            3: begin scl_t <= 1'b1;  end
          endcase
          if (count1 == clk_count1 * 4 - 1) begin
            if (r_ack == 1'b0) begin 
              ack_err <= 1'b0;
              sda_en<=1'b1;
              sda_t <= 1'b0;
              bitcount<=0;
              state <= STOP; 
            end else begin
              ack_err <= 1'b1; 
              sda_en<=1'b1;
              state <= STOP;
            end
              
          end else begin
            state <= ACK_3;
          end
        end
        
   
        STOP: begin
          sda_en <= 1'b1;
          case (pulse)
            0: begin scl_t <= 1'b1; sda_t <= 1'b0; end
            1: begin scl_t <= 1'b1; sda_t <= 1'b0; end
            2: begin scl_t <= 1'b1; sda_t <= 1'b1; end
            3: begin scl_t <= 1'b1; sda_t <= 1'b1; end
          endcase
          if (count1 == clk_count1 * 4 - 1) begin
            state <= IDLE;
            scl_t <= 1'b0;
            busy<=1'b0;
            done<=1'b1;
            sda_en <= 1'b1;
          end else begin
            state <= STOP;
          end
        end
        default: state <= IDLE;
      endcase
    end
  end

  assign sda =(sda_en == 1) ? (sda_t == 0 ? 1'b0 : 1'b1) : 1'bz;
  assign scl = scl_t;

endmodule