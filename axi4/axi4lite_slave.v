module axi4lite_slave(
    
    input wire aclk,
    input wire arestn,
    
    // read address channel
    input wire [31:0] araddr,
    input wire arvalid,
    output wire arready,

    // read data channel
    output wire [31:0] rdata,
    output wire [1:0] rresp,
    output wire rvalid,
    input wire rready,

    // write address channel
    input wire [31:0] awaddr,
    input wire awvalid,
    output wire awready,

    // write data channel
    input wire [31:0] wdata,
    input wire wvalid,
    output wire wready,

    // write response
    output wire [1:0] bresp,
    output wire bvalid, 
    input wire bready

);

// rresp or bresp
// 0b00 - OKAY
// 0b01 - EXOKAY
// 0b10 - SLVERR
// 0b11 - DECERR



endmodule