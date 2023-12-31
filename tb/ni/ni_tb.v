`timescale 1ns / 1ps
`include "../../ni/ni.v"

module ni_tb();
    
    parameter ADDRSIZE = 5;
    parameter MSB_SLOT = 5;
    localparam RSIZE = 1<<MSB_SLOT-1;
    localparam DSIZE = 1<<MSB_SLOT;

    reg clk;
    reg reset;
    reg [RSIZE-1:0] core_write_data;
    reg [RSIZE-1:0] core_write_addr;
    reg core_write_en;
    reg core_read_en;
    wire [RSIZE-1:0] core_read_data;

    // Instantiate the FIFO module
    ni #(.ADDRSIZE(ADDRSIZE), .MSB_SLOT(MSB_SLOT)) my_ni (
        .clk(clk),
        .reset(reset),
        .core_write_data(core_write_data),
        .core_write_addr(core_write_addr),
        .core_write_en(core_write_en),
        .core_read_data(core_read_data),
        .core_read_en(core_read_en)
    );

    integer i;
    // VCD dump file
    initial begin
        $dumpfile("ni_tb.vcd");
        $dumpvars(0, ni_tb);
        for(i = 0; i < 32; i = i + 1)
            $dumpvars(1, ni_tb.my_ni.write_fifo.fifo_ff[i]);

        // Initialize signals
        clk = 1;
        reset = 1;
        core_write_en = 1'b0;
        core_read_en = 1'b0;
        core_write_addr = 16'h0;
        core_write_data = 16'h0;

        #20;
        // Release reset
        reset = 1'b0;
        // Write data to the FIFO
        core_write_en = 1'b1;
        core_read_en = 1'b0;
        core_write_addr = 16'hA5A5;
        core_write_data = 16'hAAAA;

        #20;

        core_write_en = 1'b0;
        core_read_en = 1'b1;
        core_write_addr = 16'h0;
        core_write_data = 16'h0;

        #20;
        reset = 1;
        core_write_en = 1'b0;
        core_read_en = 1'b0;
        core_write_addr = 16'h0;
        core_write_data = 16'h0;

        #10;
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
