`include "../../axi4/axi4lite_slave.v"
`include "../../fifo/gp_fifo.v"

/*
File : ni.v
Description: This is the NoC side of things with a 
    axi4lite slave for core side and signals to send and recv 
    flits from NoC side. 
*/

module ni(
    
    input clk,
    input reset,

    // Should handle how write_en is generated 
    input wire [RSIZE-1:0] core_write_data,
    input wire [RSIZE-1:0] core_write_addr,
    input wire core_write_en,

    // Should handle how read_en is generated 
    // thresholed signal should be an output   
    output wire [RSIZE-1:0] core_read_data,
    // output wire [31:0] core_read_addr,
    input wire core_read_en

    // this will be an interrupt which in turn would handle the read_en
    // the threshold can be set to be of a packet size ?  
    // output wire [4:0] core_ocup
    
    // output wire core_empty,
    // output wire core_full,

    // output wire core_error,

);

    // packet size
    // Note: RSIZE denotes the 16 bits for two sections
    // of the 32 bit word
    parameter ADDRSIZE = 5;
    parameter MSB_SLOT = 5;
    localparam RSIZE = 1<<MSB_SLOT-1;
    localparam DSIZE = 1<<MSB_SLOT;

    // Define Slave at input 
    // this will be the entry for NI 
    // handle master seperately 
    

    // // to be used by master axi4lite interface 
    // wire [31:0] axi4_write_data;
    // wire [31:0] axi4_write_addr;
    // wire axi4_write_en;

    // // to be used by master axi4lite interface
    // wire [31:0] axi4_read_data;
    // wire [31:0] axi4_read_addr;
    // wire axi4_read_en;

    // output wire axi4_full;
    // output wire axi4_empty;

    // output wire axi4_error,
    // output wire [4:0] axi4_ocup

    wire [DSIZE-1:0] core_data_in,core_data_out;//axi4_data_in,axi4_data_out;

    // [data , addr ]  => [MSB,LSB]
    // assign core_data_in[63:32] = core_write_data;
    // assign core_data_in[31:0]  = core_write_addr;

    // assign axi4_data_in[63:32] = axi4_write_data;
    // assign axi4_data_in[31:0]  = axi4_write_addr;
    
    // assign core_read_data = core_data_out[63:32];
    // assign core_read_addr = core_data_out[31:0];

    // assign axi4_read_data = axi4_data_out[63:32]; 
    // assign axi4_read_addr = axi4_data_out[31:0]; 

    reg awvalid,wvalid,bready;
    reg arvalid,rready;

    wire awready,wready,bvalid,arready,rvalid;
    wire [1:0] bresp,rresp;
    

    wire read_en, empty, write_en, full,error;
    wire [DSIZE-1:0] read_data;
    wire [DSIZE-1:0] write_data,read64_data;
    wire [MSB_SLOT:0] ocup;

    assign read_data = read64_data[DSIZE-1:0];
    
    // creating axi4 master behaviour within ni
    always@(posedge clk)begin
        if(reset)begin
            awvalid = 1'b0;
            wvalid = 1'b0;
            bready = 1'b0;
        end
        if(core_write_en)begin 
            awvalid = 1'b1;
            wvalid = 1'b1;
            bready = 1'b1;
        end
        if(bready && bvalid)
            #2 bready = 1'b0;
        if(awvalid && awready)
            awvalid = 1'b0;
        if(wvalid && wready)
            wvalid = 1'b0;
        if(arvalid && arready)
            arvalid = 1'b0;
        if(rvalid && rready)
            rready = 1'b0;
    end

    always@(posedge clk)begin
        if(reset)begin
            arvalid = 1'b0;
            rready = 1'b0;
        end
        if(core_read_en)begin
            arvalid = 1'b1;
            rready = 1'b1;
        end
    end 

    axi4lite_slave slave(
        .aclk(clk),
        .arestn(!reset),
        
        // read address channel
        .araddr(32'h0),
        .arvalid(arvalid),
        .arready(arready),

        // read data channel
        .rdata(core_read_data),
        .rresp(rresp),
        .rvalid(rvalid),
        .rready(rready),

        // write address channel
        .awaddr(core_write_addr),
        .awvalid(awvalid),
        .awready(awready),

        // write data channel
        .wdata(core_write_data),
        .wvalid(wvalid),
        .wready(wready),

        // write response
        .bresp(bresp),
        .bvalid(bvalid), 
        .bready(bready),

        // For fifo access
        .read_en(read_en),
        .read_data(read_data),
        .empty(empty),

        .write_en(write_en),
        .write_data(write_data),
        .full(full)
    );

    // // Async fifo 
    async_fifo #(.DSIZE(DSIZE), .ADDRSIZE(ADDRSIZE)) write_fifo(
        .rdata(read64_data), 
        wfull, 
        rempty, 
        wdata, 
        winc, 
        wclk, 
        wrst_n, 
        rinc, 
        rclk, 
        rrst_n
    ); 

    // for testing going to read write to the same fifo
    // after verifying axi4lite slave modifies fifo as expected 
    // change to core and  ni read/write
    gp_fifo #(.LENGTH(1<<ADDRSIZE),.MSB_SLOT(ADDRSIZE),.DEPTH(DSIZE)) write_fifo (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(write_data),
        .data_out(read64_data),
        .error(error),
        .full(full),
        .empty(empty),
        .ocup(ocup)
    );
    
    // gp_fifo read_fifo (
    //     .clk(clk),
    //     .reset(reset),
    //     .write_en(axi4_write_en),
    //     .read_en(core_read_en),
    //     .data_in(axi4_data_in),
    //     .data_out(core_data_out),
    //     .error(axi4_error),
    //     .full(core_full),
    //     .empty(axi4_empty),
    //     .ocup(core_ocup)
    // );
    

    // always@(posedge clk)begin
    //     //FIFO behaviour here for data exchange through slave
    // end


endmodule