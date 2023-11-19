`timescale 1ns / 1ps
`include "../../axi4/axi4lite_slave.v"

/*

timing checks on 
https://www.realdigital.org/doc/a9fee931f7a172423e1ba73f66ca4081


*/
module axi4lite_slave_tb();
    
    reg clk;
    reg arestn;
    
    // read address channel
    reg [31:0] araddr;
    reg arvalid;
    wire arready;

    // read data channel
    wire [31:0] rdata;
    wire [1:0] rresp;
    wire rvalid;
    reg rready;

    // write address channel
    reg [31:0] awaddr;
    reg awvalid;
    wire awready;

    // write data channel
    reg [31:0] wdata;
    reg wvalid;
    wire wready;

    // write response
    wire [1:0] bresp;
    wire bvalid; 
    reg bready;
    
    // fifo 
    wire read_en;
    reg [31:0] read_data;
    reg empty;

    wire write_en;
    wire [63:0] write_data;
    reg full;

    // Instantiate the FIFO module
    axi4lite_slave my_slave (
        clk,
        arestn,
        araddr,
        arvalid,
        arready,
        rdata,
        rresp,
        rvalid,
        rready,
        awaddr,
        awvalid,
        awready,
        wdata,
        wvalid,
        wready,
        bresp,
        bvalid, 
        bready,
        read_en,
        read_data,
        empty,
        write_en,
        write_data,
        full
    );

    // VCD dump file
    initial begin
        $dumpfile("axi4slave_tb.vcd");
        $dumpvars(0, axi4lite_slave_tb);
        
        //Initialize
        clk = 1;
        arestn = 0;
        araddr = 32'h0;
        arvalid = 1'b0;
        rready = 1'b0;
        awaddr = 32'h0;
        awvalid = 1'b0;
        wdata = 32'h0;
        wvalid = 1'b0;
        bready = 1'b0;

        read_data = 32'h0;
        empty = 1'b0;
        full = 1'b0;
 
        #10;
        // write transaction
        arestn = 1;

        #20;
        araddr = 32'h00000000;
        arvalid = 1'b0;
        rready = 1'b0;
        awaddr = 32'hA5A5A5A5;
        awvalid = 1'b1;
        wdata = 32'hB5B5B5B5;
        wvalid = 1'b1;
        bready = 1'b1;

        #20;
        araddr = 32'h00000000;
        arvalid = 1'b0;
        rready = 1'b0;
        awaddr = 32'h00000000;
        wdata = 32'h00000000;
        
        #20;
        araddr = 32'hA5A5A5A5;
        arvalid = 1'b1;
        rready = 1'b1;
        awaddr = 32'h00000000;
        awvalid = 1'b0;
        wdata = 32'h00000000;
        wvalid = 1'b0;
        bready = 1'b0;

        #40;
        
        #10;
        // Perform additional read and write operations as needed
        // End simulation
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // axi master control 
    always@(posedge clk)begin
        if(bready && bvalid)
            #2 bready = 1'b0;
        if(awvalid && awready)
            awvalid = 1'b0;
        if(wvalid && wready)
            wvalid = 1'b0;
        if(arvalid && arready)
            arvalid = 1'b0;
        if(rvalid && rready)
            rready = 1'b0;
    end

endmodule
