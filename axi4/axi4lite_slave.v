module axi4lite_slave(
    
    input wire aclk,
    input wire arestn,
    
    // read address channel
    input wire [31:0] araddr,
    input wire arvalid,
    output reg arready,

    // read data channel
    output wire [31:0] rdata,
    output wire [1:0] rresp,
    output reg rvalid,
    input wire rready,

    // write address channel
    input wire [31:0] awaddr,
    input wire awvalid,
    output reg awready,

    // write data channel
    input wire [31:0] wdata,
    input wire wvalid,
    output wire wready,

    // write response
    output wire [1:0] bresp,
    output reg bvalid, 
    input wire bready,
    
    // For fifo access
    output wire read_en,
    input wire [31:0] read_data,
    input wire empty,

    output wire write_en,
    output wire [63:0] write_data,
    input wire full

);

    // rresp or bresp
    // 0b00 - OKAY
    // 0b01 - EXOKAY
    // 0b10 - SLVERR
    // 0b11 - DECERR



    /* Hanlding Write operation from Master

    - Master Puts data and address and asserts AWVALID, WVALID, BREADY
    - Slave asserts AWREADY and WRREADY when ready to accept. Master deasserts valid and ready on bothe address and data
    - ASsert BVALID 
    - Deassert both in BVALID and BREADY are high

    */



    /* Handling Read operation from Master

    - Read address, ARVALID, RREADY from master.
    - ARREADY by slave
    - ARVALID and ARREADY deasserted 
    - puts requested data on bus and RVALID
    - Since both RREADY and RVALID , deasserted

    */

    assign	reset = !arestn;
    assign	wready = awready;

    assign rresp = 2'b00;
    assign bresp = 2'b00;


    assign write_en = bvalid; 
    assign read_en = rvalid;

    initial	awready = 1'b0;
    initial	bvalid = 1'b0;
    initial rvalid = 1'b0;
    initial arready = 1'b0;



    assign write_data = {awaddr, wdata};
    assign rdata =  read_data;
    // write operation
    always @ (posedge aclk)begin

        if(reset)
        begin
            bvalid <= 1'b0;
            rvalid <=1'b0; 
            // Clear FIFO
        end
        else if(wready)begin
            // write to FIFO        
            bvalid <= 1'b1;
        end
        else if(bready && bvalid)
            bvalid <= 1'b0;
        
    end
    
    always @(posedge aclk)begin
        if(reset)
            awready <= 1'b0;
        else 
            awready <= !awready 
            && (awvalid && wvalid)
            && (!bvalid || bready);
    end


    // read operation 
    always@(posedge aclk)begin
        if (reset)begin
            arready =1'b0;
        end
        if (arvalid)
            arready <= 1'b1;
        if (arvalid && arready)begin
            arready <= 1'b0;
            rvalid <=1'b1;
        end
        else if (rready && rvalid)begin
            rvalid <= 1'b0;
        end
    end
    


/*
Instead of registers we are using fifo 
disregards address as reg address or fifo address. 
Can we use address to append to data and use the whole thing
to be stored in the fifo

Leaving strobe write out for this implementation

*/

endmodule