module mux_5to1 (
  input wire [0:4] data_inputs, // 4 input lines
  input wire [2:0] ctrl,        // 2-bit control signal
  output wire mux_output
);

  assign mux_output = (ctrl == 3'b000) ? data_inputs[0] :
                     (ctrl == 3'b001) ? data_inputs[1] :
                     (ctrl == 3'b010) ? data_inputs[2] :
                     (ctrl == 3'b011) ? data_inputs[3] :
                     (ctrl == 3'b100) ? data_inputs[4] :
                     1'bz; // Output is tri-stated when control value is invalid

endmodule
