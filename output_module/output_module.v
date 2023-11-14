/*

File: output_module.v
Descripton: Output module holds 5 VC buffers
    with rr_arbitter to output


VC buffers are 
10 bit x 32 slots

*/

`include "utils/vc_buffer.v"

module output_module(
    input wire clk, 
    input wire reset, 
    input wire [9:0] data_in;
    input reg read_en;
    input reg write_en;
    output wire [9:0] data_out; 
    
);

    `define N 3'b000
    `define S 3'b001
    `define E 3'b010
    `define W 3'b011
    `define L 3'b100


    vc_buffer vc_N(
        clk,
        reset,
        write_en_N,
        read_en_N,
        data_in,
        data_N,
        error_N,
        full_N,
        empty_N,
        ocup_N
    );

endmodule