`timescale 1ns / 1ps
`include "../../input_module/input_router.v"

module input_router_tb();
    
    reg clk;
    reg reset;
    reg [DSIZE-1:0] data_in;
    // reg [2:0] port;
    // reg [RRSIZE-1:0] router_x;
    // reg [RRSIZE-1:0] router_y;
    wire [2:0] vc_select;
    
    localparam MSB_SLOT = 5;
    localparam DSIZE = 1<<MSB_SLOT;
    localparam RRSIZE = 1<<MSB_SLOT-2;
    
    // xy - 1'b0
    // yx - 1'b1 
    localparam algorithm = 1'b0;
    localparam  [2:0] PORT = 0; 
    localparam  [RRSIZE-1:0] ROUTER_X = 0;
    localparam  [RRSIZE-1:0] ROUTER_Y = 0;
    

    // Instantiate the router module
    input_router #(.MSB_SLOT(MSB_SLOT),.DSIZE(DSIZE),.RRSIZE(RRSIZE),.algorithm(algorithm),.PORT(PORT),.ROUTER_X(ROUTER_X),.ROUTER_Y(ROUTER_Y)) router (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .vc_select(vc_select)
    );

    integer i;
    // VCD dump file
    initial begin
        $dumpfile("input_router_tb.vcd");
        $dumpvars(0, input_router_tb);

        // Initialize signals
        clk = 1;
        reset = 1;
        data_in = 32'h0;
        // port=3'b0;
        // router_x =8'h0;
        // router_y = 8'h0;

        #20;
        // Release reset
        reset = 1'b0;

        data_in = 32'h0201BBBB;
        // port=3'b000;
        // router_x =8'h00;
        // router_y = 8'h00;
        // should select E

        #20;

        data_in = 32'h01000001;
        // port=3'b000;
        // router_x =8'h01;
        // router_y = 8'h00;
        //should select N

        #20;
        data_in = 32'h0001BBBB;
        // port=3'b001;
        // router_x =8'h00;
        // router_y = 8'h01;
        // should select W

        #20;
        data_in = 32'h01020000;
        // port=3'b000;
        // router_x =8'h00;
        // router_y = 8'h00;
        // should select S
        

        // Last instruction doesnt get read here
        #20;
        data_in = 32'h01020000;
        // port=3'b000;
        // router_x =8'h00;
        // router_y = 8'h00;
        // should select S

        // #40;
        // reset = 0;
        // Perform additional read and write operations as needed
        // End simulation
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

endmodule
