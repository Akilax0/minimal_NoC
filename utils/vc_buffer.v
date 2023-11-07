/*

File: vc_buffer.v
Descripton: Virtual Buffer where internally FIFO

Virtual buffers to be use in input and 
output modules of the noc

64 slots of 8 bits

*/

module vc_buffer(
    input clk,
    input reset,
    input write_en,
    input read_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg error,
    output reg full,
    output reg empty,
    output reg [5:0] ocup
);

    // this is one less than MSB (32bit -> 5 )
    `define MSB_SLOT 5

    reg [7:0] fifo_ff [63:0]; 
    reg [`MSB_SLOT:0] write_ptr_ff,read_ptr_ff, next_write_ptr, next_read_ptr,fifo_ocup;

    always@*begin
        next_read_ptr = read_ptr_ff;
        next_write_ptr = write_ptr_ff;

        empty = (write_ptr_ff == read_ptr_ff);
        full = (write_ptr_ff[`MSB_SLOT-1:0] == read_ptr_ff[`MSB_SLOT-1:0] )  && (write_ptr_ff[`MSB_SLOT]!= read_ptr_ff[`MSB_SLOT]);
                
        data_out = empty ? 0 : fifo_ff[read_ptr_ff[`MSB_SLOT-1:0]];
        
        if (write_en && ~full)
            next_write_ptr = write_ptr_ff + 1'b1;

        if (read_en && ~empty)
            next_read_ptr = read_ptr_ff + 1'b1;

        error = (write_en && full) || (read_en && empty);
        fifo_ocup = write_ptr_ff - read_ptr_ff;
        ocup = fifo_ocup;
    end

    integer i;
    always@(posedge clk or posedge reset)begin
        if(reset) begin
            write_ptr_ff <= 1'b0;
            read_ptr_ff <= 1'b0;
            for (i = 0; i < 64; i = i + 1)
            begin
                fifo_ff[i] <= 0;       // Write zero to all registers
            end
        end
        else begin
            write_ptr_ff <= next_write_ptr;
            read_ptr_ff <= next_read_ptr;
            if (write_en && ~full)
                fifo_ff[write_ptr_ff[`MSB_SLOT-1:0]] <= data_in;
        end
    end
endmodule