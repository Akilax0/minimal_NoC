module rr_arbiter(
  input wire clk,
  input wire reset,
  input wire [2:0] request, // 3 request inputs
  output wire grant
);

    reg [2:0] next_grant;
    reg [1:0] round_robin_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
          round_robin_counter <= 2'b00;
          next_grant <= 3'b000;
        end 
        else begin
          if (request != 3'b000) begin
            if (request[round_robin_counter]) begin
              next_grant <= {2'b00, request[round_robin_counter]};
            end
            round_robin_counter <= round_robin_counter + 1;
          end
        end
    end

    always @(*) begin
        grant = next_grant[0];
    end

endmodule



endmodule