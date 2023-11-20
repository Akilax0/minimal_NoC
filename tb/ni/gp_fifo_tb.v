`timescale 1ns / 1ps
`include "../../fifo/gp_fifo.v"

module gp_fifo_tb();

    // Define testbench signals
    reg clk;
    reg reset;
    reg write_en;
    reg read_en;
    reg [63:0] data_in;
    wire [63:0] data_out;
    wire error;
    wire full;
    wire empty;
    wire [4:0] ocup;

    // Instantiate the FIFO module
    gp_fifo my_fifo (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),
        .data_out(data_out),
        .error(error),
        .full(full),
        .empty(empty),
        .ocup(ocup)
    );

    // VCD dump file
    initial begin
        $dumpfile("gp_fifo_tb.vcd");
        $dumpvars(0, gp_fifo_tb);

        // Initialize signals
        clk = 1;
        reset = 1;
        write_en = 1'b0;
        read_en = 1'b0;
        data_in = 64'h0;

        #10;
        // Release reset
        reset = 1'b0;
        // Write data to the FIFO
        write_en = 1;
        data_in = 64'hA5A5A5A5A5A5A5A5; // Example data
        
        #10;
        // Release reset
        reset = 1'b0;
        // Write data to the FIFO
        write_en = 1;
        data_in = 64'h00000000BBBBBBBB; // Example data

        #10;
        // Write data to the FIFO
        write_en = 1;
        data_in = 64'h00010001BBBBBBBB; // Example data


        #10;
        write_en = 0;
        // Read data from the FIFO
        read_en = 1;


        #10;
        read_en = 1;
        write_en = 1;
        data_in = 64'h00010001CCCCCCCC; // Example data

        #10;
        write_en = 0;
        // Read data from the FIFO
        read_en = 1;

        #10;
        write_en = 0;
        // Read data from the FIFO
        read_en = 1;

        #10;
        read_en = 0;
        write_en = 0;
        #40;
        // Perform additional read and write operations as needed
        // End simulation
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

endmodule
