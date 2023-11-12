module output_module(
    input wire clk, 
    input wire reset, 
    input wire [7:0] data_in;
    input reg read_en;
    input reg write_en;
    output wire [7:0] data_out; 
    
);