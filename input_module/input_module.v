/*
File: input_module.v
Descripton: input module that holds input router 
    and 4 VC buffers coresponding to the 4 other directions
    
Assumption : read_en and write_en are synchronous

Decided to go for 32bit (from 10 bit flits) packets rather than flit division 
change this later on if congestion becomes a problem . 
But considering Networks common packet size for all should 
not be a problem - Akilax0

VC buffers are 
32 bit x 32 slots

CAN USE SIGNALS OF FIFO FOR LATER FLOW CONTROL
*/

`include "../../input_module/input_router.v"
`include "../../input_module/input_controller.v"
`include "../../fifo/vc_buffer.v"
`include "../../utils/rr_arbiter.v"
`include "../../utils/demux_1to5.v"
// `include "../../utils/mux_5to1.v"
// `include "../../utils/mux_5to1_64bit.v"

module input_module(
    input wire clk, 
    input wire reset, 
    input wire [DSIZE-1:0] data_in,

    input wire input_empty, // checks if write buffer of NI is not empty
    output wire input_read,

    output wire [DSIZE-1:0] data_out,

    // signal from output side to read from vc_buffers
    input wire read_en,
    
    // check if this is needed to be output
    output wire [2:0] vc_select
    
    // // for output module flow control
    // // [L,W,E,S,N]
    // input wire [4:0] recv_full;
);

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

    parameter MSB_SLOT = 5;
    parameter DSIZE = 1<<MSB_SLOT;
    parameter RRSIZE = 1<<MSB_SLOT-2;

    parameter ADDRSIZE = 5;
    parameter DEPTH = 1<<ADDRSIZE;

    // Assigning straight 0 to avoid defining bit width 
    parameter [2:0] PORT = 0;
    parameter [RRSIZE-1:0] ROUTER_X = 0;
    parameter [RRSIZE-1:0] ROUTER_Y = 0;
    parameter algorithm = 0;

    // signal to check virtual buffers have empty space
    wire buffer_empty;
    wire write_en;
    wire [4:0] read_empty;

    assign buffer_empty = !full_N && !full_S && !full_E && !full_W && !full_L;
    
    // Need to figure a better way for this
    // check vc select signal here should be able to resolve this 
    assign write_en = (vc_select!=`INVALID && !reset && input_empty)? 1'b1 : 1'b0;
    // assign read_empty = !empty_N || !empty_E || !empty_L || !empty_S || !empty_W; 
    
    assign read_empty = {!empty_L,!empty_W,!empty_E,!empty_S,!empty_N}; // 5 request inputs , and with not full 

    // Signals to the module checked
    input_controller controller(
        .clk(clk),
        .reset(reset),
        .input_empty(input_empty),
        .buffer_empty(buffer_empty),
        .input_read(input_read)
    );
    
    // Need a router output to 
    // enable signal
    // Need additional check to not pass back 
    // Only consider as data packets 

    input_router#(.MSB_SLOT(MSB_SLOT),.DSIZE(DSIZE),.RRSIZE(RRSIZE),.algorithm(algorithm),.PORT(PORT),.ROUTER_X(ROUTER_X),.ROUTER_Y(ROUTER_Y)) ir(
        .clk(clk), 
        .reset(reset),
        .data_in(data_in),
        .vc_select(vc_select) // check if this is needed to be output
    );
    
    // signals for the 5 virtual channels
    wire write_en_N, write_en_S, write_en_E, write_en_W;
    wire read_en_N, read_en_S, read_en_E, read_en_W;
    
    wire error_N, error_S,error_E,error_W;
    wire full_N,full_S,full_E,full_W;
    wire empty_N,empty_S,empty_E,empty_W;
    wire [MSB_SLOT-1:0] ocup_N,ocup_S,ocup_E,ocup_W;
    
    wire [2:0] rr_select;

    // // for Local port
    wire write_en_L;
    wire read_en_L;
    wire error_L, full_L, empty_L;
    wire [MSB_SLOT-1:0] ocup_L;
    

    // // Handling data out
    wire [DSIZE-1:0] data_N, data_S,data_E, data_W, data_L;
    
    // write_en is going to be set to 1'b1 . Remove this if write en is going to be conditional
    // This should be discussed
    demux_1to5 write_enable(write_en,vc_select,write_en_N,write_en_S,write_en_E,write_en_W,write_en_L);
    

    demux_1to5 read_enable(read_en,rr_select,read_en_N,read_en_S,read_en_E,read_en_W,read_en_L);
    
    // mux_5to1 full({full_N,full_S,full_E,full_W,full_L},vc_select,full);
    // mux_5to1 empty({empty_N,empty_S,empty_E,empty_W,empty_L},rr_select,empty);
    // mux_5to1 error({error_N,error_S,error_E,error_W,error_L},rr_select,error);

    // mux_5to1_64bit data(data_N,data_S,data_E,data_W,data_L,rr_select,data_out);
    
    // // add  for ocup to check flow control

    vc_buffer #(.MSB_SLOT(MSB_SLOT),.ADDRSIZE(ADDRSIZE),.DSIZE(DSIZE),.DEPTH(DEPTH)) vc_N(
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

    vc_buffer #(.MSB_SLOT(MSB_SLOT),.ADDRSIZE(ADDRSIZE),.DSIZE(DSIZE),.DEPTH(DEPTH)) vc_S(
        clk,
        reset,
        write_en_S,
        read_en_S,
        data_in,
        data_S,
        error_S,
        full_S,
        empty_S,
        ocup_S
    );

    vc_buffer #(.MSB_SLOT(MSB_SLOT),.ADDRSIZE(ADDRSIZE),.DSIZE(DSIZE),.DEPTH(DEPTH)) vc_E(
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

    vc_buffer #(.MSB_SLOT(MSB_SLOT),.ADDRSIZE(ADDRSIZE),.DSIZE(DSIZE),.DEPTH(DEPTH)) vc_W(
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

    vc_buffer #(.MSB_SLOT(MSB_SLOT),.ADDRSIZE(ADDRSIZE),.DSIZE(DSIZE),.DEPTH(DEPTH)) vc_L(
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
        read_empty,  // input wire [4:0] {!empty_L,!empty_W,!empty_E,!empty_S,!empty_N}, // 5 request inputs , and with not full 
        rr_select
    );

endmodule