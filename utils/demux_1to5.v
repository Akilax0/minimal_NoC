module demux_1to5 (
  input wire data_input,  // Input data to be demultiplexed
  input wire [2:0] ctrl,        // Control signal to select an output
  output wire out0,       // Demuxed output 0
  output wire out1,       // Demuxed output 1
  output wire out2,       // Demuxed output 2
  output wire out3,        // Demuxed output 3
  output wire out4        // Demuxed output 3
);

  assign out0 = (ctrl == 3'b000) ? data_input : 1'b0;
  assign out1 = (ctrl == 3'b001) ? data_input : 1'b0;
  assign out2 = (ctrl == 3'b010) ? data_input : 1'b0;
  assign out3 = (ctrl == 3'b011) ? data_input : 1'b0;
  assign out4 = (ctrl == 3'b100) ? data_input : 1'b0;

endmodule
