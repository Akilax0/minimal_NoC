`include "../../fifo/async_fifo.v"
`include "../../inst/swnet.v"
`include "../../inst/lwnet.v"

/*

File : ni_test.v
Description : Testing NI implementations included modules

MSB are the 16 bits of destination router address.
LSB 16 bits which is the neuron address. 


NI without AXI4 lite interface which directly reads and writes from Async FIFOS 
used for synchornous message passing when communicating with the NoC

*/

module ni_test(
    input clk,
    input reset,

    // control signal 
    input wire core_write_en,
    input wire core_read_en,
    // inputs from core
    input wire [RSIZE-1:0] core_wdata,
    input wire [RSIZE-1:0] core_waddr,
    // outputs to core 
    output wire core_wfull,
    
    output wire [RSIZE-1:0] core_rdata,
    output wire core_rempty,


    // Outputs to NoC
    output wire [DSIZE-1:0] noc_rdata,
    output wire noc_rempty,

    output wire noc_wfull,
    

    // Inputs from NoC
    input noc_clk, 
    input noc_reset,
    input wire noc_read_en,
    
    input wire [DSIZE-1:0] noc_wdata,
    input wire noc_write_en 


);

    // Parameters 
    // ADDRSIZE -> shows length of FIFOS
    // MSB_SLOT -> shows depth of FIFO or DATA size
    // DSIZE -> full packet size 
    // RSIZE -> half a packet size
    parameter ADDRSIZE = 5;
    parameter MSB_SLOT = 5;
    localparam DSIZE = 1<<MSB_SLOT;
    localparam RSIZE = 1<<MSB_SLOT-1;
    
    // Temporary outputs and inputs to check 
    // beahviour of all modules 
    // for fifo write buffer
    wire ni_wfull;
    wire [RSIZE-1:0] ni_wdata;
    wire [RSIZE-1:0] ni_waddr;
    wire ni_write_en;
    
    wire ni_rempty;
    wire [RSIZE-1:0] ni_rdata;
    wire ni_read_en;
    
    wire [DSIZE-1:0] write_data;
    wire [DSIZE-1:0] read_data;

    swnet #(.ADDRSIZE(ADDRSIZE),.MSB_SLOT(MSB_SLOT)) sw_net (
       .clk(clk),
       .reset(reset),
       .core_wdata(core_wdata),
       .core_waddr(core_waddr),
       .core_wfull(core_wfull),
       .ni_wfull(ni_wfull),
       .ni_wdata(ni_wdata),
       .ni_waddr(ni_waddr),
       .core_write_en(core_write_en),
       .ni_write_en(ni_write_en)
    ); 

    lwnet #(.ADDRSIZE(ADDRSIZE),.MSB_SLOT(MSB_SLOT)) lw_net (
       .clk(clk),
       .reset(reset),
       .core_rdata(core_rdata),
       .core_rempty(core_rempty),
       .ni_rempty(ni_rempty),
       .ni_rdata(ni_rdata),
       .core_read_en(core_read_en),
       .ni_read_en(ni_read_en)
    ); 

    // create the immediate wires
    // concat addr and data or divide them from moving to and from FIFO as 
    // the FIFOs hold 32bit entries
    assign write_data = {ni_waddr, ni_wdata};
    assign ni_rdata = read_data[15:0]; 

    async_fifo #(.DSIZE(DSIZE),.ADDRSIZE(ADDRSIZE)) write_fifo(
        .rdata(noc_rdata),
        .wfull(ni_wfull),
        .rempty(noc_rempty),
        .wdata(write_data),
        .winc(ni_wrtite_en),
        .wclk(clk),
        .wrst_n(~reset),
        .rinc(noc_read_en),
        .rclk(noc_clk), 
        .rrst_n(~noc_reset) 
    ); 

    async_fifo #(.DSIZE(DSIZE),.ADDRSIZE(ADDRSIZE)) read_fifo(
        .rdata(read_data),
        .wfull(noc_wfull),
        .rempty(ni_empty),
        .wdata(noc_wdata),
        .winc(noc_write_en),
        .wclk(noc_clk), 
        .wrst_n(~noc_reset), 
        .rinc(ni_read_en),
        .rclk(clk), 
        .rrst_n(~reset) 
    ); 

endmodule