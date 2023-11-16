module fifomem (
    output [63:0] rdata,
    input [63:0] wdata,
    input [63:0] waddr, raddr,
    input wclken, wfull, wclk
);

    // RTL Verilog memory model
    localparam DEPTH = 1<<5;
    reg [63:0] mem [0:DEPTH-1];

    assign rdata = mem[raddr];

    always @(posedge wclk)
        if (wclken && !wfull) mem[waddr] <= wdata;
endmodule