`timescale 1ns / 1ps
`include "../../fifo/async_fifo.v"

module async_fifo_tb();

    localparam  DSIZE = 32;
    localparam  ADDRSIZE = 5;

    // Define testbench signals
    wire [DSIZE-1:0] rdata;
    wire wfull;
    wire rempty; 

    reg [DSIZE-1:0] wdata; 
    reg winc, wclk, wrst_n; 
    reg rinc, rclk, rrst_n;


    // Instantiate the FIFO module
    async_fifo #(.ADDRSIZE(ADDRSIZE), .DSIZE(DSIZE)) my_fifo(
        .rdata(rdata),
        .wfull(wfull),
        .rempty(rempty), 
        .wdata(wdata), 
        .winc(winc),
        .wclk(wclk), 
        .wrst_n(wrst_n), 
        .rinc(rinc), 
        .rclk(rclk), 
        .rrst_n(rrst_n)
    ); 
    


    // VCD dump file
    initial begin
        $dumpfile("async_fifo_tb.vcd");
        $dumpvars(0, async_fifo_tb);

        // Initialize signals
        wclk = 1;
        rclk = 1;
        wrst_n = 0;
        rrst_n = 0;

        winc = 0;
        rinc = 0;
        wdata = 32'h0;

        #20;
        // Release reset
        wrst_n = 1;
        rrst_n = 1;

        winc = 1;
        rinc = 0;
        wdata = 32'h0000BBBB;

        // Have to deassert winc before next clock posedge for correct
        // operation 

        #5;
        winc = 0;
        
        #20;

        winc = 1;
        rinc = 0;
        wdata = 32'h00010001;

        #20;

        winc = 1;
        rinc = 0;
        wdata = 32'h00010001;

        #20;
        winc = 0;
        rinc = 1;

        #20;
        winc = 1;
        rinc = 1;
        wdata = 32'h0100CCCC;

        #20;
        winc = 0;
        rinc = 1;

        #20;
        winc = 0;
        rinc = 1;

        #20;
        winc = 0;
        rinc = 0;

        #40;
        // Perform additional read and write operations as needed
        // End simulation
        $finish;
    end

    // Clock generation
    always begin
        #5 wclk = ~wclk;
    end
    always begin
        #10 rclk = ~rclk;
    end

endmodule
