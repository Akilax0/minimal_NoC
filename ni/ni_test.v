`include "../../fifo/async_fifo.v"
`include "../../inst/swnet.v"
`include "../../inst/lwnet.v"

/*

File : ni_test.v
Description : Testing NI implementations included modules

MSB are the 16 bits of destination router address.
LSB 16 bits which is the neuron address. 

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

    // Inputs from NoC
    

    // Temporary outputs and inputs to check 
    // beahviour of all modules 
    // for fifo write buffer
    input wire ni_wfull,
    output wire [RSIZE-1:0] ni_wdata,
    output wire [RSIZE-1:0] ni_waddr,
    output wire ni_write_en,
    
    input wire ni_rempty,
    input wire [RSIZE-1:0] ni_rdata,
    output wire ni_read_en

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
    
    // for fifo write buffer
    // wire ni_wfull;
    // wire [RSIZE-1:0] ni_wdata;
    // wire [RSIZE-1:0] ni_waddr;

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
    

endmodule