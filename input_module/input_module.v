/*
File: input_module.v
Descripton: input module that holds input router 
    and 4 VC buffers coresponding to the 4 other directions
    
Assumption : read_en and write_en are synchronous

Decided to go for 64bit (from 10 bit flits) packets rather than flit division 
change this later on if congestion becomes a problem . 
But considering Networks common packet size for all should 
not be a problem - Akilax0

VC buffers are 
64 bit x 32 slots

CAN USE SIGNALS OF FIFO FOR LATER FLOW CONTROL
*/

`include "input_module/input_router.v"
`include "utils/vc_buffer.v"
`include "utils/rr_arbiter.v"
`include "utils/demux_1to5.v"
`include "utils/mux_5to1.v"
`include "utils/mux_5to1_64bit.v"

module input_module(
    input wire clk, 
    input wire reset, 
    input wire [63:0] data_in;
    input reg read_en;
    input reg write_en;
    output wire [63:0] data_out; 

    // input router calculations 
    input wire [2:0] port;
    input wire [15:0] router_x;
    input wire [15:0] router_y;
    
    output wire [2:0] vc_select;
    
    // for output module flow control
    // [L,W,E,S,N]
    input wire [4:0] recv_full;
);

    reg write_en_N, write_en_S, write_en_E, write_en_W;
    reg read_en_N, read_en_S, read_en_E, read_en_W;
    
    wire error_N, error_S,error_E,error_W;
    wire full_N,full_S,full_E,full_W;
    wire empty_N,empty_S,empty_E,empty_W;
    wire [4:0] ocup_N,ocup_S,ocup_E,ocup_W;
    
    wire [2:0] rr_select;

    // for Local port
    reg write_en_L, read_en_L;
    wire error_L, full_L, empty_L;
    wire [4:0] ocup_L;
    

    // Handling data out
    wire [63:0] data_N, data_S,data_E, data_W, data_L;
    

    // Need a router output to 
    // enable signal
    // Need additional check to not pass back 
    // Only consider as flits 
    
    // vc_select gives out the selected directions
    // North -> 3'b000
    // South -> 3'b001
    // East -> 3'b010
    // West -> 3'b011
    // Local -> 3'b100
    
    `define N 3'b000
    `define S 3'b001
    `define E 3'b010
    `define W 3'b011
    `define L 3'b100
    `define INVALID 3'b111

    input_router ir(
        clk, 
        reset,
        data_in;
        port;
        router_x;
        router_y;
        vc_select;
    );
    
    demux_1to5 write_en(write_en,vc_select,write_en_N,write_en_S,write_en_E,write_en_W,write_en_L);
    demux_1to5 read_en(read_en,rr_select,read_en_N,read_en_S,read_en_E,read_en_W,read_en_L);
    
    mux_5to1 full({full_N,full_S,full_E,full_W,full_L},vc_select,full);
    mux_5to1 empty({empty_N,empty_S,empty_E,empty_W,empty_L},rr_select,empty);
    mux_5to1 error({error_N,error_S,error_E,error_W,error_L},rr_select,error);

    mux_5to1_64bit data(data_N,data_S,data_E,data_W,data_L,rr_select,data_out);
    
    // add  for ocup to check flow control


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

    vc_buffer vc_S(
        clk,
        reset,
        write_en_S,
        read_en_S,
        data_in,
        data_S,
        error_S,
        fullS_S,
        empty_S,
        ocup_S
    );

    vc_buffer vc_E(
        clk,
        reset,
        write_en_E,
        read_en_E,
        data_in,
        data_E,
        error_E,
        full_E,
        empty_E,
        ocup_E
    );

    vc_buffer vc_W(
        clk,
        reset,
        write_en_W,
        read_en_W,
        data_in,
        data_W,
        error_W,
        full_W,
        empty_W,
        ocup_W
    );

    vc_buffer vc_L(
        clk,
        reset,
        write_en_L,
        read_en_L,
        data_in,
        data_L,
        error_L,
        full_L,
        empty_L,
        ocup_L
    );


    rr_arbiter arb(
      clk,
      reset,
      input wire [4:0] {!empty_L,!empty_W,!empty_E,!empty_S, !empty_N}, // 5 request inputs , and with not full 
      output reg [2:0] rr_select
    );

endmodule