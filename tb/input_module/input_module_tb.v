`timescale 1ns / 1ps
`include "../../input_module/input_module.v"

module input_module_tb();
    
    reg clk;
    reg reset;
    reg [DSIZE-1:0] data_in;
    reg input_empty;
    reg input_read;
    wire [DSIZE-1:0] data_out; 
    
    // check if this is needed to be output
    wire [2:0] vc_select;

    `define N 3'b000
    `define S 3'b001
    `define E 3'b010
    `define W 3'b011
    `define L 3'b100
    `define INVALID 3'b111

    parameter MSB_SLOT = 5;
    parameter DSIZE = 1<<MSB_SLOT;
    parameter RRSIZE = 1<<MSB_SLOT-2;

    // input router calculations 
    localparam [2:0] PORT = 0;
    localparam [RRSIZE-1:0] ROUTER_X = 0;
    localparam [RRSIZE-1:0] ROUTER_Y = 0;

    // Instantiate the router module
    input_module #(.MSB_SLOT(MSB_SLOT),.DSIZE(DSIZE),.RRSIZE(RRSIZE),.PORT(PORT),.ROUTER_X(ROUTER_X),.ROUTER_Y(ROUTER_Y)) input (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .input_empty(input_empty),
        .input_read(input_read),
        .data_out(data_out),
        .vc_select(vc_select)
    );

    integer i;
    // VCD dump file
    initial begin
        $dumpfile("input_module.vcd");
        $dumpvars(0, input_module_tb);

        // Initialize signals
        clk = 1;
        reset = 1;

        data_in = 32'h00010001;
        input_empty = 1'b1;
        input_read = 1'b0;

        #20;
        // Release reset
        reset = 1'b0;

        flit = 64'hAAAAAAAA;
        port=3'b011;
        router_x =16'h0001;
        router_y = 16'h0000;
        // should select S

        #20;

        flit = 64'h00010001CCCCCCCC;
        port=3'b000;
        router_x =16'h0000;
        router_y = 16'h0001;
        //should select E

        #20;
        flit = 64'h00010001BBBBBBBB;
        port=3'b000;
        router_x =16'h0000;
        router_y = 16'h0000;
        // what does this select E?
        // 

        #20;
        flit = 64'h00000000BBBBBBBB;
        port=3'b000;
        router_x =16'h0000;
        router_y = 16'h0001;

        #40;
        reset = 0;
        // Perform additional read and write operations as needed
        // End simulation
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

endmodule
