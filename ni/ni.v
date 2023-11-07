`include "../../axi4/axi4lite_master.v"
`include "../../axi4/axi4lite_slave.v"
`include "../../ni/gp_fifo.v"

/*
File : ni.v
Description: This is the NoC side of things with a 
    axi4lite slave for core side and signals to send and recv 
    flits from NoC side. 
*/

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
    output wire [4:0] core_ocup
    
    output wire core_empty,
    output wire core_full,

    output wire core_error,

);


    // Define Slave at input 
    // this will be the entry for NI 
    // handle master seperately 
    

    // to be used by master axi4lite interface 
    input wire [31:0] axi4_write_data;
    input wire [31:0] axi4_write_addr;
    input wire axi4_write_en;

    // to be used by master axi4lite interface
    output wire [31:0] axi4_read_data;
    output wire [31:0] axi4_read_addr;
    input wire axi4_read_en;

    output wire axi4_full;
    output wire axi4_empty;

    output wire axi4_error,
    output wire [4:0] axi4_ocup

    wire [63:0] core_data_in,core_data_out,axi4_data_in,axi4_data_out;

    // [data , addr ]  => [MSB,LSB]
    assign core_data_in[63:32] = core_write_data;
    assign core_data_in[31:0]  = core_write_addr;

    assign axi4_data_in[63:32] = axi4_write_data;
    assign axi4_data_in[31:0]  = axi4_write_addr;
    
    assign core_read_data =  core_data_out[63:32];
    assign core_read_addr =  core_data_out[31:0];

    assign axi4_read_data = axi4_data_out[63:32]; 
    assign axi4_read_addr = axi4_data_out[31:0]; 

    axi4lite_slave slave(
        .aclk(clk),
        .arestn(~reset),
        
        // read address channel
        .araddr(araddr),
        .arvalid(arvalid),
        arready(arready),

        // read data channel
        .rdata(rdata),
        .rresp(rresp),
        .rvalid(rvalid),
        .rready(rready),

        // write address channel
        .awaddr(awaddr),
        .awvalid(awvalid),
        .awready(awready),

        // write data channel
        .wdata(wdata),
        .wvalid(wvalid),
        .wready(wready),

        // write response
        .bresp(bresp),
        .bvalid(bvalid), 
        .bready(bready)
    );


    gp_fifo write_fifo (
        .clk(clk),
        .reset(reset),
        .write_en(core_write_en),
        .read_en(axi4_read_en),
        .data_in(core_data_in),
        .data_out(axi4_data_out),
        .error(core_error),
        .full(axi4_full),
        .empty(core_empty),
        .ocup(axi4_ocup)
    );
    
    gp_fifo read_fifo (
        .clk(clk),
        .reset(reset),
        .write_en(axi4_write_en),
        .read_en(core_read_en),
        .data_in(axi4_data_in),
        .data_out(core_data_out),
        .error(axi4_error),
        .full(core_full),
        .empty(axi4_empty),
        .ocup(core_ocup)
    );
    

    always@(posedge clk)begin
        //FIFO behaviour here for data exchange through slave
    end


endmodule