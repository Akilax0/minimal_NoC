/*

File : async_fifo.v
Description: Top module file for the async fifo 

Ref: Cummings

64 bit x 32 slots

Have to test this implementation before integration

*/

`include "fifo/async_fifo_util/fifo_mem.v"
`include "fifo/async_fifo_util/sync_r2w.v"
`include "fifo/async_fifo_util/sync_w2r.v"
`include "fifo/async_fifo_util/rptr_empty.v"
`include "fifo/async_fifo_util/wptr_full.v"


module async_fifo(
    output [DEPTH-1:0] rdata, 
    output wfull, 
    output rempty, 
    input [DEPTH-1:0] wdata, 
    input winc, wclk, wrst_n, 
    input rinc, rclk, rrst_n
); 
    
    parameter LENGTH = 32;
    parameter DEPTH = 32;
    parameter MSB_SLOT = 4;

    wire [MSB_SLOT:0] waddr, raddr; 
    wire [MSB_SLOT:0] wptr, rptr, wq2_rptr, rq2_wptr; 

    sync_r2w sync_r2w (
        .wq2_rptr(wq2_rptr), 
        .rptr(rptr), 
        .wclk(wclk), 
        .wrst_n(wrst_n)
    ); 
        
    sync_w2r sync_w2r (
        .rq2_wptr(rq2_wptr), 
        .wptr(wptr), 
        .rclk(rclk), 
        .rrst_n(rrst_n)
    ); 
        
    fifomem #(.LENGTH(LENGTH) , .MSB_SLOT(MSB_SLOT), .DEPTH(DEPTH)) fifomem (
        .rdata(rdata), 
        .wdata(wdata), 
        .waddr(waddr), 
        .raddr(raddr), 
        .wclken(winc), 
        .wfull(wfull), 
        .wclk(wclk)
    ); 
        
    rptr_empty rptr_empty (
        .rempty(rempty), 
        .raddr(raddr), 
        .rptr(rptr), 
        .rq2_wptr(rq2_wptr), 
        .rinc(rinc), 
        .rclk(rclk), 
        .rrst_n(rrst_n)
    ); 
    
    wptr_full wptr_full (
        .wfull(wfull), 
        .waddr(waddr), 
        .wptr(wptr), 
        .wq2_rptr(wq2_rptr), 
        .winc(winc), 
        .wclk(wclk), 
        .wrst_n(wrst_n)
    ); 

endmodule