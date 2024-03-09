`timescale 1ns / 1ps
`include "../../input_module/input_module.v"

module input_module_tb();
    
    reg clk;
    reg reset;
    reg [DSIZE-1:0] data_in;
    reg input_empty;
    reg read_en;
    wire input_read;
    wire [DSIZE-1:0] data_out; 
    
    // check if this is needed to be output
    wire [2:0] vc_select;

    `define N 3'b000
    `define S 3'b001
    `define E 3'b010
    `define W 3'b011
    `define L 3'b100
    `define INVALID 3'b111

    localparam MSB_SLOT = 5;
    localparam DSIZE = 1<<MSB_SLOT;
    localparam RRSIZE = 1<<MSB_SLOT-2;

    localparam ADDRSIZE = 5;
    localparam DEPTH = 1<<ADDRSIZE;

    // input router calculations 
    localparam [2:0] PORT = 3'b000;
    localparam [RRSIZE-1:0] ROUTER_X = 1;
    localparam [RRSIZE-1:0] ROUTER_Y = 1;
    localparam algorithm = 0;

    // Instantiate the router module
    input_module #(.MSB_SLOT(MSB_SLOT),.DSIZE(DSIZE),.RRSIZE(RRSIZE),.ADDRSIZE(ADDRSIZE),.DEPTH(DEPTH),.PORT(PORT),.ROUTER_X(ROUTER_X),.ROUTER_Y(ROUTER_Y),.algorithm(algorithm)) im (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .input_empty(input_empty),
        .input_read(input_read),
        .data_out(data_out),
        .read_en(read_en),
        .vc_select(vc_select)
    );

    integer i;
    // VCD dump file
    initial begin
        $dumpfile("input_module_tb.vcd");
        $dumpvars(0, input_module_tb);

        // Initialize signals
        clk = 1;
        reset = 1;

        data_in = 32'h00000000;
        input_empty = 1'b0;
        read_en = 1'b0;

        #20;
        // Release reset
        reset = 0;

        data_in = 32'h01020001;
        input_empty = 1'b1;
        read_en = 1'b0;
        //South

        #20;
        data_in = 32'h00010001;
        input_empty = 1'b1;
        read_en = 1'b0;
        // West
        //
        #20;
        input_empty = 1'b0;
        read_en = 1'b1;

        #20;
        input_empty = 1'b0;
        read_en = 1'b1;

        #20;
        input_empty = 1'b0;
        read_en = 1'b1;

        #20;
        input_empty = 1'b0;
        read_en = 1'b1;
        
        
        // data_in = 32'h01000001;
        // input_empty = 1'b1;
        // read_en = 1'b0;
        // // North but same port

        // #20;

        // data_in = 32'h01020001;
        // input_empty = 1'b1;
        // read_en = 1'b0;
        // //South

        // #20;
        // data_in = 32'h00010001;
        // input_empty = 1'b1;
        // read_en = 1'b0;
        // // West

        // #20;

        // data_in = 32'h01020002;
        // input_empty = 1'b1;
        // read_en = 1'b0;
        // //South

        #20;

        
        input_empty = 1'b0;


        // #20;
        // data_in = 32'h01020002;
        // input_empty = 1'b0;
        // read_en = 1'b1;
        // // East


        // #20;
        // data_in = 32'h02010001;
        // input_empty = 1'b1;
        // read_en = 1'b0;
        // // East

        // #20;
        // data_in = 32'h02010001;
        // input_empty = 1'b1;
        // read_en = 1'b1;
        // // East

        #40;
        reset = 0;
        // Perform additional read and write operations as needed
        // End simulation
        $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

endmodule
