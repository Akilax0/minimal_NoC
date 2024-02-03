/*

File:  rr_arbiter.v
Descripton: Arbiter to chose between vc buffers which to 
output. 

Check before rrarbiter choice if data available
if not empty && rrarbiter 


The arbiter has an FSM to cycle throough the choices

*/

module rr_arbiter(
  input wire clk,
  input wire reset,
  input wire [4:0] request, // 5 request inputs
  output reg [2:0] grant
);

  // for grant 
  `define N 3'b000
  `define S 3'b001
  `define E 3'b010
  `define W 3'b011
  `define L 3'b100
  `define INVALID 3'b111

  reg [2:0] state;
  reg [2:0] next_state;

  // check what count is for
  reg [1:0] count;
  

  parameter [2:0] s_ideal = 3'b101 ;
  parameter [2:0] s0 = 3'b000 ;
  parameter [2:0] s1 = 3'b001 ;
  parameter [2:0] s2 = 3'b010 ;
  parameter [2:0] s3 = 3'b011 ;
  parameter [2:0] s4 = 3'b100 ; 

  always @ (posedge clk or posedge reset)begin
    if(reset) 
      state <= s_ideal;
    else
      state <= next_state;
  end

  initial state = s_ideal;

  always @ (state, next_state)begin
    case(state)
      s_ideal: begin
        if (request[0])begin
          next_state = s0;
        end
        else if (request[1])begin
          next_state = s1;
        end
        else if (request[2])begin
          next_state = s2;
        end
        else if (request[3])begin
          next_state = s3;
        end
        else if (request[4])begin
          next_state = s4;
        end
        else begin
          next_state = s_ideal;
        end
      end
      s0: begin
        if (request[1])begin
          next_state = s1;
        end
        else if (request[2])begin
          next_state = s2;
        end
        else if (request[3])begin
          next_state = s3;
        end
        else if (request[4])begin
          next_state = s4;
        end
        else if (request[0])begin
          next_state = s0;
        end
        else begin
          next_state = s_ideal;
        end
      end
      s1: begin
        if (request[2])begin
          next_state = s2;
        end
        else if (request[3])begin
          next_state = s3;
        end
        else if (request[4])begin
          next_state = s4;
        end
        else if (request[0])begin
          next_state = s0;
        end
        else if (request[1])begin
          next_state = s1;
        end
        else begin
          next_state = s_ideal;
        end
      end
      s2: begin
        if (request[3])begin
          next_state = s3;
        end
        else if (request[4])begin
          next_state = s4;
        end
        else if (request[0])begin
          next_state = s0;
        end
        else if (request[1])begin
          next_state = s1;
        end
        else if (request[2])begin
          next_state = s2;
        end
        else begin
          next_state = s_ideal;
        end
      end
      s3: begin
        if (request[4])begin
          next_state = s4;
        end
        else if (request[0])begin
          next_state = s0;
        end
        else if (request[1])begin
          next_state = s1;
        end
        else if (request[2])begin
          next_state = s2;
        end
        else if (request[3])begin
          next_state = s3;
        end
        else begin
          next_state = s_ideal;
        end
      end
      s4: begin
        if (request[0])begin
          next_state = s0;
        end
        else if (request[1])begin
          next_state = s1;
        end
        else if (request[2])begin
          next_state = s2;
        end
        else if (request[3])begin
          next_state = s3;
        end
        else if (request[4])begin
          next_state = s4;
        end
        else begin
          next_state = s_ideal;
        end
      end
      default: begin
        if (request[0])begin
          next_state = s0;
        end
        else if (request[1])begin
          next_state = s1;
        end
        else if (request[2])begin
          next_state = s2;
        end
        else if (request[3])begin
          next_state = s3;
        end
        else if (request[4])begin
          next_state = s4;
        end
        else begin
          next_state = s_ideal;
        end
      end

    endcase
  end  
  

  always @(state) begin
      case(state)
        s0: begin grant=`N; end
        s1: begin grant=`S; end
        s2: begin grant=`E; end
        s3: begin grant=`W; end
        s4: begin grant=`L; end
        default: begin grant = `INVALID; end
      endcase
  end

endmodule