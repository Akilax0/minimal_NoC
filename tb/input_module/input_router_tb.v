`timescale 1ns / 1ps
`include "../../input_module/input_router.v"

module input_router_tb();
    
    reg clk;
    reg reset;
    reg [DSIZE-1:0] data_in;
    reg [2:0] port;
    reg [RRSIZE-1:0] router_x;
    reg [RRSIZE-1:0] router_y;
    wire [2:0] vc_select;
    
    localparam MSB_SLOT = 5;
    localparam DSIZE = 1<<MSB_SLOT;
    localparam RRSIZE = 1<<MSB_SLOT-2;

    // Instantiate the router module
    input_router #(.MSB_SLOT(MSB_SLOT),.DSIZE(DSIZE),.RRSIZE(RRSIZE)) router (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
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
        data_in = 32'h0;
        port=3'b0;
        router_x =8'h0;
        router_y = 8'h0;

        #20;
        // Release reset
        reset = 1'b0;

        data_in = 32'h0100BBBB;
        port=3'b000;
        router_x =8'h00;
        router_y = 8'h00;
        // should select E

        #20;

        data_in = 32'h00000001;
        port=3'b000;
        router_x =8'h01;
        router_y = 8'h00;
        //should select W

        #20;
        data_in = 32'h0000BBBB;
        port=3'b001;
        router_x =8'h00;
        router_y = 8'h01;
        // should select N

        #20;
        data_in = 32'h00010000;
        port=3'b000;
        router_x =8'h00;
        router_y = 8'h00;
        // should select S

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
