`timescale 1ns/1ps
`include "../../input_module/input_controller.v"


module input_controller_tb();

    reg clk;
    reg reset;
    reg input_empty;
    reg buffer_empty;
    wire input_read;

    //Instatiate the input controller 
    input_controller controller(
        .clk(clk),
        .reset(reset),
        .input_empty(input_empty),
        .buffer_empty(buffer_empty),
        .input_read(input_read)
    );
    
    integer i;

    initial begin
        $dumpfile("input_controller_tb.vcd");
        $dumpvars(0,input_controller_tb);

        //Intital signals
        clk = 1'b1;
        reset = 1'b1;
        input_empty = 1'b1;
        buffer_empty = 1'b0;

        #20;
        reset = 1'b0;
        input_empty = 1'b0;
        buffer_empty = 1'b1;
        
        #20;
        reset = 1'b0;
        input_empty = 1'b0;
        buffer_empty = 1'b1;

        #20;
        reset = 1'b0;
        input_empty = 1'b1;
        buffer_empty = 1'b1;
        
        
        #20;
        reset = 1'b0;
        input_empty = 1'b1;
        buffer_empty = 1'b0;
        
        #20;
        reset = 1'b0;
        input_empty = 1'b0;
        buffer_empty = 1'b0;
        
        #20;

        $finish;

    end



    // Clock generation
    always begin
        #5 clk = ~clk;
    end


endmodule