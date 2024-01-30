/*

File: swnet.v
Description: Module to handle store word to network operation. 
Directly interfaces with core and aysnc fifos in Network interface 
to handle the instructions operation. 

Core wdata and waddr taken from SWNET instruction

Check later for additional requirements

*/

module swnet(
    input clk,
    input reset, 

    // inputs from core
    input wire [RSIZE-1:0] core_wdata,
    input wire [RSIZE-1:0] core_waddr,
    // outputs to core 
    output wire core_wfull,
    
    // input from NoC 
    input wire ni_wfull,
    // outputs to NoC
    output wire [RSIZE-1:0] ni_wdata
    output wire [RSIZE-1:0] ni_waddr
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

    // Direct assigning to the outputs 
    assign ni_wdata = core_wdata;
    assign ni_waddr = core_waddr;
    assign core_wfull = ni_wfull;
    
endmodule