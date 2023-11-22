module fifomem (
    output [DEPTH-1:0] rdata,
    input [DEPTH-1:0] wdata,
    input [MSB_SLOT:0] waddr, raddr,
    input wclken, wfull, wclk
);

    parameter DEPTH = 32;
    parameter LENGTH = 32;
    parameter MSB_SLOT = 4;

    // RTL Verilog memory model
    // localparam DEPTH = 1<<5;
    //
    reg [LENGTH-1:0] mem [0:DEPTH-1];

    assign rdata = mem[raddr];

    always @(posedge wclk)
        if (wclken && !wfull) mem[waddr] <= wdata;
endmodule