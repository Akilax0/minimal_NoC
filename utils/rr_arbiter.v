/*

File:  rr_arbiter.v
Descripton: Arbiter to chose between vc buffers which to 
output. 

Have to add extra bit -> 5 choices


Check before rrarbiter choic if data available
if not empty && rrarbiter


The arbiter has an FSM to cycle throough the choices

*/

module rr_arbiter(
  input wire clk,
  input wire reset,
  input wire [3:0] request, // 4 request inputs
  output reg [2:0] grant
);

  reg [2:0] state;
  reg [2:0] next_state;
  reg [1:0] count;
  

  parameter [2:0] s_ideal = 3'b101 ;
  parameter [2:0] s0 = 3'b000 ;
  parameter [2:0] s1 = 3'b001 ;
  parameter [2:0] s2 = 3'b010 ;
  parameter [2:0] s3 = 3'b011 ;
  parameter [2:0] s3 = 3'b100 ;
  

  always @ (posedge clk or posedge reset)begin
    if(reset ) 
      state = s_ideal;
    else
      state = next_state;
  end
  
  always @ (state , next_state, count)begin
    case(state)

      s0:begin
        if(request[0])begin
          if(count == 2'b11)begin
            if(request[1])begin
              count = 2'b00;
              next_state = s1;
            end
            else if (request[2])begin
              count = 2'b00;
              next_state = s2;
            end
            else if (request[3])begin
              count = 2'b00;
              next_state = s3;
            end
            else begin
              count = 2'b00;
              next_state = s0;
            end
          end
          else begin
            count = count + 2'b01;
            next_state = s0;
          end
        end
        else if(request[1])begin
          count = 2'b00;
          next_state = s1;
        end
        else if(request[2])begin
          count = 2'b00;
          next_state = s2;
        end
        else if(request[3])begin
          count = 2'b00;
          next_state = s3;
        end
        else begin
          count = 2'b00;
          next_state = s_ideal;
        end
      end // case s0

      s1:begin
        if(request[1])begin
          if(count == 2'b11)begin
            if(request[2])begin
              count = 2'b00;
              next_state = s2;
            end
            else if (request[3])begin
              count = 2'b00;
              next_state = s3;
            end
            else if (request[0])begin
              count = 2'b00;
              next_state = s0;
            end
            else begin
              count = 2'b00;
              next_state = s1;
            end
          end
          else begin
            count = count + 2'b01;
            next_state = s1;
          end
        end
        else if(request[2])begin
          count = 2'b00;
          next_state = s2;
        end
        else if(request[3])begin
          count = 2'b00;
          next_state = s3;
        end
        else if(request[0])begin
          count = 2'b00;
          next_state = s0;
        end
        else begin
          count = 2'b00;
          next_state = s_ideal;
        end
      end // case s1

      s2:begin
        if(request[2])begin
          if(count == 2'b11)begin
            if(request[3])begin
              count = 2'b00;
              next_state = s3;
            end
            else if (request[0])begin
              count = 2'b00;
              next_state = s0;
            end
            else if (request[1])begin
              count = 2'b00;
              next_state = s1;
            end
            else begin
              count = 2'b00;
              next_state = s2;
            end
          end
          else begin
            count = count + 2'b01;
            next_state = s2;
          end
        end
        else if(request[3])begin
          count = 2'b00;
          next_state = s3;
        end
        else if(request[0])begin
          count = 2'b00;
          next_state = s0;
        end
        else if(request[1])begin
          count = 2'b00;
          next_state = s1;
        end
        else begin
          count = 2'b00;
          next_state = s_ideal;
        end
      end // case : s2

      s3:begin
        if(request[3])begin
          if(count == 2'b11)begin
            if(request[0])begin
              count = 2'b00;
              next_state = s0;
            end
            else if (request[1])begin
              count = 2'b00;
              next_state = s1;
            end
            else if (request[2])begin
              count = 2'b00;
              next_state = s2;
            end
            else begin
              count = 2'b00;
              next_state = s3;
            end
          end
          else begin
            count = count + 2'b01;
            next_state = s3;
          end
        end
        else if(request[0])begin
          count = 2'b00;
          next_state = s0;
        end
        else if(request[1])begin
          count = 2'b00;
          next_state = s1;
        end
        else if(request[2])begin
          count = 2'b00;
          next_state = s2;
        end
        else begin
          count = 2'b00;
          next_state = s_ideal;
        end 
      end // case : s3

      default:
        begin
          if(request[0])begin
            count = 2'b00;
            next_state = s0;
          end
          else if (request[1]) begin
            count = 2'b00;
            next_state = s1;
          end
          else if (request[2]) begin
            count = 2'b00;
            next_state = s2;
          end
          else if (request[3]) begin
            count = 2'b00;
            next_state = s3;
          end
          else begin
            count = 2'b00;
            next_state = s_ideal;
          end
        end
    endcase
  end  
  

  always @(state, next_state, count)
    begin
      case(state)
        s0: begin grant=3'b000; end
        s1: begin grant=3'b001; end
        s2: begin grant=3'b010; end
        s3: begin grant=3'b011; end
        s4: begin grant=3'b100; end
        default: begin grant = 3'b111; end
    end
  endmodule

    // reg [2:0] next_grant;
    // reg [1:0] round_robin_counter;

    // always @(posedge clk or posedge reset) begin
    //     if (reset) begin
    //       round_robin_counter <= 2'b00;
    //       next_grant <= 3'b000;
    //     end 
    //     else begin
    //       if (request != 3'b000) begin
    //         if (request[round_robin_counter]) begin
    //           next_grant <= {2'b00, request[round_robin_counter]};
    //         end
    //         round_robin_counter <= round_robin_counter + 1;
    //       end
    //     end
    // end

    // always @(*) begin
    //     grant = next_grant[0];
    // end

endmodule