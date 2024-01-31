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
    
    wire [DSIZE-1:0] noc_rdata;
    wire noc_rempty;
    wire noc_wfull;
    
    reg noc_clk, noc_reset;
    reg noc_read_en,noc_write_en;
    reg [DSIZE-1:0] noc_wdata;

    // reg ni_wfull;
    // wire [RSIZE-1:0] ni_wdata;
    // wire [RSIZE-1:0] ni_waddr;

    // wire ni_write_en;
    // reg ni_rempty;
    // reg [RSIZE-1:0] ni_rdata;
    // wire ni_read_en;
    

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
        .noc_rdata(noc_rdata),
        .noc_rempty(noc_rempty),
        .noc_wfull(noc_wfull),
        .noc_clk(noc_clk),
        .noc_reset(noc_reset),
        .noc_read_en(noc_read_en),
        .noc_wdata(noc_wdata),
        .noc_write_en(noc_write_en)
    );
        // .ni_wfull(ni_wfull),
        // .ni_wdata(ni_wdata),
        // .ni_waddr(ni_waddr),
        // .ni_write_en(ni_write_en),
        // .ni_rempty(ni_rempty),
        // .ni_rdata(ni_rdata),
        // .ni_read_en(ni_read_en)
    
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

        core_wdata = 16'h0;
        core_waddr = 16'h0;
        
        noc_clk = 1;
        noc_reset = 1;

        noc_read_en = 0;
        noc_write_en = 0;

        noc_wdata = 32'h0;

        // ni_wfull = 1'b0;

        // ni_rempty = 1'b0;
        // ni_rdata = 16'b0;

        #20;
        // both core and noc writes at the same time to the two FIFOS
        reset = 0;
        noc_reset = 0;

        core_write_en = 1;
        core_read_en = 0;

        core_wdata = 16'hAAAA;
        core_waddr = 16'hBBBB;
        

        noc_read_en = 0;
        noc_write_en = 1;

        noc_wdata = 32'hABABABAB;

        
        #20;
        // both core and noc reads at the same time from the two FIFOS
        reset = 0;
        noc_reset = 0;

        core_write_en = 0;
        core_read_en = 1;

        core_wdata = 16'h0;
        core_waddr = 16'h0;
        

        noc_read_en = 1;
        noc_write_en = 0;

        noc_wdata = 32'h0;

        #10;
        reset = 0;

        // End simulation
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
        #5 noc_clk = ~noc_clk;
    end

endmodule