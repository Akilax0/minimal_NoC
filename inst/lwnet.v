/*

File: lwnet.v
Description: Module to load word from network operation. 
Directly interfaces with core and aysnc fifos in Network interface 
to handle the instructions operation. 

Core wdata and waddr taken from SWNET instruction

Check later for additional requirements

*/

module lwnet(
    input clk,
    input reset, 

    // lets get a signal through
    // control unit here
    input wire core_read_en,

    // inputs from core
    output wire [RSIZE-1:0] core_rdata,

    // outputs to core 
    output wire core_rempty,


    output wire ni_read_en, 
    // input from NoC 
    input wire ni_rempty,
    // outputs to NoC
    input wire [RSIZE-1:0] ni_rdata
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
    assign core_rdata = ni_rdata;
    assign core_rempty = ni_rempty;
    assign ni_read_en = core_read_en;
    
endmodule