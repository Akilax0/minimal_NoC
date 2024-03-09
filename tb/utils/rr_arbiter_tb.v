`timescale 1ns/1ps
`include "../../utils/rr_arbiter.v"

module rr_arbiter_tb();

    reg clk;
    reg reset;
    reg [4:0] request; // 5 request inputs
    wire [2:0] grant;

    //Instatiate the round robin arrbitter 
    rr_arbiter arb(
        .clk(clk),
        .reset(reset),
        .request(request),
        .grant(grant)
    );
    
    integer i;

    initial begin
        $dumpfile("rr_arbiter_tb.vcd");
        $dumpvars(0,rr_arbiter_tb);

        //Intital signals
        clk = 1'b1;
        reset = 1'b1;
        request = 5'b00000;

        #15;
        reset = 1'b0;
        request = 5'b00001;
        
        #10;
        reset = 1'b0;
        request = 5'b00100;

        #10;
        reset = 1'b0;
        request = 5'b00100;

        #10;
        reset = 1'b0;
        request = 5'b00110;
        
        
        #10;
        reset = 1'b0;
        request = 5'b01000;
        
        #10;
        reset = 1'b0;
        request = 5'b10000;
        
        #20;

        $finish;

    end



    // Clock generation
    always begin
        #5 clk = ~clk;
    end


endmodule