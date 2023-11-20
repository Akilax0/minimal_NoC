`timescale 1ns / 1ps
`include "../../input_module/input_router.v"

module input_router_tb();
    
    reg clk;
    reg reset;
    reg [63:0] flit;
    reg [2:0] port;
    reg [15:0] router_x;
    reg [15:0] router_y;
    wire [2:0] vc_select;

    // Instantiate the router module
    input_router router (
        .clk(clk),
        .reset(reset),
        .flit(flit),
        .port(port),
        .router_x(router_x),
        .router_y(router_y),
        .vc_select(vc_select)
    );

    integer i;
    // VCD dump file
    initial begin
        $dumpfile("input_router_tb.vcd");
        $dumpvars(0, input_router_tb);

        // Initialize signals
        clk = 1;
        reset = 1;
        flit = 64'h0;
        port=3'b0;
        router_x =16'h0;
        router_y = 16'h0;

        #20;
        // Release reset
        reset = 1'b0;

        flit = 64'h00010001AAAAAAAA;
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
