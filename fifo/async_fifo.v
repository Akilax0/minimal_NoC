/*

File : async_fifo.v
Description: Top module file for the async fifo 

Ref: Cummings

64 bit x 32 slots

Have to test this implementation before integration

*/

`include "../../fifo/async_fifo_util/fifo_mem.v"
`include "../../fifo/async_fifo_util/sync_r2w.v"
`include "../../fifo/async_fifo_util/sync_w2r.v"
`include "../../fifo/async_fifo_util/rptr_empty.v"
`include "../../fifo/async_fifo_util/wptr_full.v"


module async_fifo(
    output [DSIZE-1:0] rdata, 
    output wfull, 
    output rempty, 
    input [DSIZE-1:0] wdata, 
    input winc, wclk, wrst_n, 
    input rinc, rclk, rrst_n
); 
    
    parameter DSIZE = 32;
    parameter ADDRSIZE = 5;

    wire [ADDRSIZE-1:0] waddr, raddr; 
    // extra bit used to check for full/empty
    wire [ADDRSIZE:0] wptr, rptr, wq2_rptr, rq2_wptr; 

    sync_r2w #(.ADDRSIZE(ADDRSIZE)) sync_r2w (
        .wq2_rptr(wq2_rptr), 
        .rptr(rptr), 
        .wclk(wclk), 
        .wrst_n(wrst_n)
    ); 
        
    sync_w2r #(.ADDRSIZE(ADDRSIZE))sync_w2r (
        .rq2_wptr(rq2_wptr), 
        .wptr(wptr), 
        .rclk(rclk), 
        .rrst_n(rrst_n)
    ); 
        
    fifomem #(.ADDRSIZE(ADDRSIZE), .DSIZE(DSIZE)) fifomem (
        .rdata(rdata), 
        .wdata(wdata), 
        .waddr(waddr), 
        .raddr(raddr), 
        .wclken(winc), 
        .wfull(wfull), 
        .wclk(wclk)
    ); 
        
    rptr_empty #(.ADDRSIZE(ADDRSIZE)) rptr_empty (
        .rempty(rempty), 
        .raddr(raddr), 
        .rptr(rptr), 
        .rq2_wptr(rq2_wptr), 
        .rinc(rinc), 
        .rclk(rclk), 
        .rrst_n(rrst_n)
    ); 
    
    wptr_full #(.ADDRSIZE(ADDRSIZE))wptr_full (
        .wfull(wfull), 
        .waddr(waddr), 
        .wptr(wptr), 
        .wq2_rptr(wq2_rptr), 
        .winc(winc), 
        .wclk(wclk), 
        .wrst_n(wrst_n)
    ); 

endmodule