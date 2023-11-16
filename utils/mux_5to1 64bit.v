module mux_5to1_64bit(
  input wire [63:0] data_N,
  input wire [63:0] data_S,
  input wire [63:0] data_E,
  input wire [63:0] data_W,
  input wire [63:0] data_L,
  input wire [2:0] ctrl,        // 3-bit control signal
  output wire mux_output
);

  assign mux_output = (ctrl == 3'b000) ? data_N :
                     (ctrl == 3'b001) ? data_S :
                     (ctrl == 3'b010) ? data_E :
                     (ctrl == 3'b011) ? data_W :
                     (ctrl == 3'b100) ? data_L :
                     1'bz; // Output is tri-stated when control value is invalid

endmodule
