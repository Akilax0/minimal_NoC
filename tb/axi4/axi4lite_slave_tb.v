`timescale 1ns / 1ps
`include "../../ni/ni.v"

module ni_tb();
    
    reg clk;
    reg reset;
    reg [31:0] core_write_data;
    reg [31:0] core_write_addr;
    reg core_write_en;
    wire core_empty;
    wire core_error;
    
    wire [31:0] axi4_read_data;
    reg [31:0] axi4_read_addr;
    reg axi4_read_en;
    wire axi4_full;
    wire [4:0] axi4_ocup;

    // Instantiate the FIFO module
    ni my_ni (
        .clk(clk),
        .reset(reset),
        .core_write_data(core_write_data),
        .core_write_addr(core_write_addr),
        .core_write_en(core_write_en),
        .core_empty(core_empty),
        .core_error(core_error),
        .axi4_read_data(axi4_read_data),
        .axi4_read_addr(axi4_read_addr),
        .axi4_read_en(axi4_read_en),
        .axi4_full(axi4_full),
        .axi4_ocup(axi4_ocup)
    );

    // VCD dump file
    initial begin
        $dumpfile("ni_tb.vcd");
        $dumpvars(0, ni_tb);

        // Initialize signals
        clk = 0;
        reset = 1;
        core_write_en = 1'b0;
        axi4_read_en = 1'b0;
        core_write_data = 32'h0;
        core_write_data = 32'h0;

        #20;
        // Release reset
        reset = 1'b0;
        // Write data to the FIFO
        core_write_en = 1'b0;
        core_write_data = 64'hA5A5A5A5A5A5A5A5; // Example data
        #10;
        // Release reset
        reset = 1'b0;
        // Write data to the FIFO
        core_write_en = 1;
        core_write_data = 64'hA5A5A5A5A5A5A5A5; // Example data

        #10;
        // Release reset
        reset = 1'b0;
        // Write data to the FIFO
        core_write_en = 1;
        core_write_data = 64'hA5A5A5A5A5A5A1A5; // Example data


        #10;
        core_write_en = 0;
        // Read data from the FIFO
        axi4_read_en = 1;

        #10;
        // Perform additional read and write operations as needed
        // End simulation
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

endmodule
