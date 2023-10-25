module fifo_32x64(
    input wire clk,        // Clock signal
    input wire reset,      // Reset signal

    input wire write_en,   // Write enable signal
    input wire read_en,    // Read enable signal

    input wire [63:0] data_in, // Data input (64 bits wide)
    output reg [63:0] data_out, // Data output (64 bits wide)

    output wire full,      // Full flag
    output wire empty,      // Empty flag

    // nhandle this appropriately 
    output wire thresh
);

  // fifo module to store addr + data for network write read

  // Define FIFO parameters
  parameter FIFO_DEPTH = 32;
  parameter DATA_WIDTH = 64;

  // Internal FIFO storage
  reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];
  reg [4:0] wr_ptr; // Write pointer
  reg [4:0] rd_ptr; // Read pointer
  wire [4:0] count = wr_ptr - rd_ptr;

  // Full and empty flags
  assign full = (count == FIFO_DEPTH);
  assign empty = (count == 0);

  // Write and read logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      wr_ptr <= 5'b0;
      rd_ptr <= 5'b0;
    end 
    else begin
      if (write_en && !full) begin
        fifo[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
      end

      if (read_en && !empty) begin
        data_out <= fifo[rd_ptr];
        rd_ptr <= rd_ptr + 1;
      end
    end
  end

endmodule
