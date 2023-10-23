`include "../axi4/axi4_slave.v"
`include "../axi4/axi4_master.v"

module axi4_tb();
    // testbench signals
    reg clk;
    reg reset;

    // AXI4 master signals for write
    wire [31:0] awaddr;
    wire awvalid;
    wire awready;
    wire [31:0] wdata;
    wire [3:0] wstrb;
    wire wvalid;
    reg wready;
    reg [1:0] bresp;
    wire bvalid;
    reg bready;

    // AXI4 Master signals for read
    wire [31:0] araddr;
    wire arvalid;
    reg arready;
    reg [31:0] rdata;
    wire [1:0] rresp;
    reg rvalid;
    wire rready;

    // Instantiate AXI4 Master and Slave
    axi4_slave slave (
        clk,
        reset,
        awaddr,
        awvalid,
        awready,
        wdata,
        wstrb,
        wvalid,
        wready,
        bresp,
        bvalid,
        bready,
        araddr,
        arvalid,
        arready,
        rdata,
        rresp,
        rvalid,
        rready
        // Connect other AXI4 signals here
    );

    // axi4_slave slave (
    //     clk,
    //     reset,
    //     awaddr,
    //     awvalid,
    //     awready,
    //     wdata,
    //     wstrb,
    //     wvalid,
    //     wready,
    //     bresp,
    //     bvalid,
    //     bready,
    //     araddr,
    //     arvalid,
    //     arready,
    //     rdata,
    //     rresp,
    //     rvalid,
    //     rready;
    //   // Connect other AXI4 signals here
    // );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end
    

    // Reset control
    always begin
        #10 reset = 1;
        #10 reset = 0;
        #100 $finish;
    end

    // Testbench logic
    initial begin
        $dumpfile("axi4.vcd");
        $dumpvars(0,axi4_tb);

        #20 awvalid = 1;
        awaddr = 32'h1000; // Example address
        wdata = 32'h12345678; // Example data
        wvalid = 1;
        wstrb = 4'b1111;

        #30 arvalid = 1;
        araddr = 32'h1000; // Example address for read
        #40 arvalid = 0;      #10 wvalid = 0; 
        // Initialize and apply AXI4 transactions
        // Monitor and verify AXI4 responses
        // End simulation
    end
    
    // Read data 
    // initial begin
    //     #30 arvalid = 1;
    //     araddr = 32'h1000; // Example address for read
    //     #40 arvalid = 0;
    // end

endmodule
