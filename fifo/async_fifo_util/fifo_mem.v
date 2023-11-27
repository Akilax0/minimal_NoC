module fifomem (
    output [DSIZE-1:0] rdata,
    input [DSIZE-1:0] wdata,
    input [ADDRSIZE-1:0] waddr, raddr,
    input wclken, wfull, wclk
);

    parameter DSIZE = 32;
    parameter ADDRSIZE = 5;

    // RTL Verilog memory model
    localparam DEPTH = 1<<ADDRSIZE;
    reg [DSIZE-1:0] mem [0:DEPTH-1];

    assign rdata = mem[raddr];

    always @(posedge wclk)
        if (wclken && !wfull) mem[waddr] <= wdata;
endmodule