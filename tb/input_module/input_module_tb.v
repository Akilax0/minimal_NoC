`timescale 1ns / 1ps
`include "../../input_module/input_module.v"

module input_module_tb();
    
    reg clk;
    reg reset;
    reg [63:0] data_in;
    reg read_en;
    reg write_en;
    wire [63:0] data_out; 

    // input router calculations 
    reg [2:0] port;
    reg [15:0] router_x;
    reg [15:0] router_y;

    // Instantiate the router module
    input_module input (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
        .data_out(data_out),
        .port(port),
        .router_x(router_x),
        .router_y(router_y),
    );

    integer i;
    // VCD dump file
    initial begin
        $dumpfile("input_module.vcd");
        $dumpvars(0, input_module_tb);

        // Initialize signals
        clk = 1;
        reset = 1;
        data_in;
        read_en;
        write_en;

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
