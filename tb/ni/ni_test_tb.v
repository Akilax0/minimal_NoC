`timescale 1ns/1ps
`include "../../ni/ni_test.v"

module ni_test_tb();

    parameter ADDRSIZE = 5;
    parameter MSB_SLOT = 5;
    localparam DSIZE = 1<<MSB_SLOT;
    localparam RSIZE = 1<<MSB_SLOT-1;
    
    reg clk,reset;
    reg core_write_en,core_read_en;
    reg [RSIZE-1:0] core_wdata;
    reg [RSIZE-1:0] core_waddr;
    wire core_wfull;
    
    wire [RSIZE-1:0] core_rdata;
    wire core_rempty;

    reg ni_wfull;
    wire [RSIZE-1:0] ni_wdata;
    wire [RSIZE-1:0] ni_waddr;

    wire ni_write_en;
    reg ni_rempty;
    reg [RSIZE-1:0] ni_rdata;
    wire ni_read_en;
    

    // Instatiate NI module
    ni_test #(.ADDRSIZE(ADDRSIZE), .MSB_SLOT(MSB_SLOT)) my_ni (
        .clk(clk),
        .reset(reset),
        .core_write_en(core_write_en),
        .core_read_en(core_read_en),
        .core_wdata(core_wdata),
        .core_waddr(core_waddr),
        .core_wfull(core_wfull),
        .core_rdata(core_rdata),
        .core_rempty(core_rempty),
        .ni_wfull(ni_wfull),
        .ni_wdata(ni_wdata),
        .ni_waddr(ni_waddr),
        .ni_write_en(ni_write_en),
        .ni_rempty(ni_rempty),
        .ni_rdata(ni_rdata),
        .ni_read_en(ni_read_en)
    );
    
    integer i;
    // VCD dump files

    initial begin
        $dumpfile("ni_test_tb.vcd");
        $dumpvars(0,ni_test_tb);
        // for(i=0; i<32; i=i+1)
        //     $dumpvars(1,ni_test_tb.my_ni.// check here)
        
        // Initialize signals
        clk = 1;
        reset = 1;

        core_write_en = 0;
        core_read_en = 0;

        core_wdata = 16'b0;
        core_waddr = 16'b0;

        ni_wfull = 1'b0;

        ni_rempty = 1'b0;
        ni_rdata = 16'b0;

        #20;
        // Release reset
        reset = 1'b1;

        // Write to FIFO
        core_write_en = 1;
        core_read_en = 0;

        core_wdata = 16'hABBA;
        core_waddr = 16'hBCCB;

        ni_wfull = 1'b0;

        ni_rempty = 1'b0;
        ni_rdata = 16'b0;
        
        #20;
        // Release reset
        reset = 1'b1;

        // Read from FIFO 
        core_write_en = 0;
        core_read_en = 1;

        core_wdata = 16'h0000;
        core_waddr = 16'h0000;

        ni_wfull = 1'b0;

        ni_rempty = 1'b0;
        ni_rdata = 16'hAAAA;
        
        #20;
        // Release reset
        reset = 1'b0;

        // Write data to the FIFO
        core_wdata = 16'hCCCC;
        core_waddr = 16'hBABA;
        ni_wfull = 1'b1;
        
        #10;
        reset = 0;

        // End simulation
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

endmodule