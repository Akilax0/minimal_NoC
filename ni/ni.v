`include "../axi4/axi4lite_master.v"
`include "../axi4/axi4lite_slave.v"
`include "fifo_32x64.v"

module ni(
    
    input clk,
    input reset,

    // Should handle how write_en is generated 
    input wire [31:0] core_write_data,
    input wire [31:0] core_write_addr,
    input wire core_write_en,

    // Should handle how read_en is generated 
    // thresholed signal should be an output   
    output wire [31:0] core_read_data,
    output wire [31:0] core_read_addr,
    input wire core_read_en,

    // this will be an interrupt which in turn would handle the read_en
    // the threshold can be set to be of a packet size ?  
    output wire core_thresh,
    
    output wire core_empty,
    output wire core_full
    
);

    // to be used by master axi4lite interface 
    input wire [31:0] axi4_write_data;
    input wire [31:0] axi4_write_addr;
    input wire axi4_write_en;

    // to be used by master axi4lite interface
    output wire [31:0] axi4_read_data;
    output wire [31:0] axi4_read_addr;
    input wire axi4_read_en;

    output wire axi4_thresh;
    output wire axi4_full;
    output wire axi4_full;

    fifo_32x64 write_fifo (
        .clk(clk),
        .reset(reset),
        .write_en(core_write_en),
        .read_en(axi4_read_en),
        .data_in(data_in),
        .data_out(axi4_read_data),
        .full(axi4_full),
        .empty(core_empty),
        .thresh(axi4_thresh)
    );
    
    fifo_32x64 read_fifo (
        .clk(clk),
        .reset(reset),
        .write_en(axi4_write_en),
        .read_en(core_read_en),
        .data_in(axi4_write_data),
        .data_out(core_read_data),
        .full(core_full),
        .empty(axi4_empty),
        .thresh(axi4_thresh)
    );
    

    axi4lite_master core_master(
        input wire aclk,
        input wire arestn,
        
        // read address channel
        output wire [31:0] araddr,
        output wire arvalid,
        input wire arready,

        // read data channel
        input wire [31:0] rdata,
        input wire [1:0] rresp,
        input wire rvalid,
        output wire rready,

        // write address channel
        output wire [31:0] awaddr,
        output wire awvalid,
        input wire awready,

        // write data channel
        output wire [31:0] wdata,
        output wire wvalid,
        input wire wready,

        // write response
        input wire [1:0] bresp,
        input wire bvalid, 
        output wire bready
    );
    

endmodule