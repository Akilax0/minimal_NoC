module mux_4to1 (
  input wire [3:0] data_inputs, // 4 input lines
  input wire [1:0] ctrl,        // 2-bit control signal
  output wire mux_output
);

  assign mux_output = (ctrl == 2'b00) ? data_inputs[0] :
                     (ctrl == 2'b01) ? data_inputs[1] :
                     (ctrl == 2'b10) ? data_inputs[2] :
                     (ctrl == 2'b11) ? data_inputs[3] :
                     1'bz; // Output is tri-stated when control value is invalid

endmodule
