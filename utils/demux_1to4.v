module demux_1to4 (
  input wire data_input,  // Input data to be demultiplexed
  input wire [1:0] ctrl,        // Control signal to select an output
  output wire out0,       // Demuxed output 0
  output wire out1,       // Demuxed output 1
  output wire out2,       // Demuxed output 2
  output wire out3        // Demuxed output 3
);

  assign out0 = (ctrl == 2'b00) ? data_input : 1'b0;
  assign out1 = (ctrl == 2'b01) ? data_input : 1'b0;
  assign out2 = (ctrl == 2'b10) ? data_input : 1'b0;
  assign out3 = (ctrl == 2'b11) ? data_input : 1'b0;

endmodule
