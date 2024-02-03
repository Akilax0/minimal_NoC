`timescale 1ns / 1ps
`include "../../fifo/gp_fifo.v"

module gp_fifo_tb();

    localparam MSB_SLOT = 5;
    localparam ADDRSIZE = 5;
    localparam DSIZE = 1<<MSB_SLOT;
    localparam DEPTH = 1<<ADDRSIZE;

    // Define testbench signals
    reg clk;
    reg reset;
    reg write_en;
    reg read_en;
    reg [DEPTH-1:0] data_in;
    wire [DEPTH-1:0] data_out;
    wire error;
    wire full;
    wire empty;
    wire [MSB_SLOT:0] ocup;

    // Instantiate the FIFO module
    gp_fifo #(.MSB_SLOT(MSB_SLOT),.ADDRSIZE(ADDRSIZE), .DSIZE(DSIZE), .DEPTH(DEPTH)) my_fifo(
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

    integer i;

    // VCD dump file
    initial begin
        $dumpfile("gp_fifo_tb.vcd");
        $dumpvars(0, gp_fifo_tb);
        
        for(i = 0; i < 32; i = i + 1)
            $dumpvars(1, gp_fifo_tb.my_fifo.fifo_ff[i]);

        // Initialize signals
        clk = 1;
        reset = 1;
        write_en = 1'b0;
        read_en = 1'b0;
        data_in = 32'h0;

        #10;
        // Release reset
        reset = 1'b0;
        // Write data to the FIFO
        write_en = 1;
        data_in = 32'h0101A5A5;// Example data
        
        #10;
        // Release reset
        reset = 1'b0;
        // Write data to the FIFO
        write_en = 1;
        data_in = 32'h0000BBBB; // Example data

        #10;
        // Write data to the FIFO
        write_en = 1;
        data_in = 32'h00010001; // Example data


        #10;
        write_en = 0;
        // Read data from the FIFO
        read_en = 1;


        #10;
        read_en = 1;
        write_en = 1;
        data_in = 64'h0100CCCC; // Example data

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
