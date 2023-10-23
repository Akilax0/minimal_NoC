module axi4lite_master(
    
    input wire aclk,
    input wire arestn,
    
    // read address channel
    output wire [31:0] araddr,
    output wire arvalid,
    input wire arready,

    // read data channel
    input wire [31:0] rdata,
    input wire [1:0] rresp,
    input wire rvalid,
    output wire rready,

    // write address channel
    output wire [31:0] awaddr,
    output wire awvalid,
    input wire awready,

    // write data channel
    output wire [31:0] wdata,
    output wire wvalid,
    input wire wready,

    // write response
    input wire [1:0] bresp,
    input wire bvalid, 
    output wire bready

);

// rresp or bresp
// 0b00 - OKAY
// 0b01 - EXOKAY
// 0b10 - SLVERR
// 0b11 - DECERR



endmodule