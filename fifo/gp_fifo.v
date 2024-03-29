/*

File: gp_fifo.v
Descripton: Simple FIFO module

General purpose FIFO to handle the read and write buffer.
The whole FIFO runs on the same clock domain (ie. not the async version )

Tested for same time reads and writes

*/
module gp_fifo(
    input clk,
    input reset,
    input write_en,
    input read_en,
    input [DEPTH-1:0] data_in,
    output reg [DEPTH-1:0] data_out,
    output reg error,
    output reg full,
    output reg empty,
    output reg [MSB_SLOT:0] ocup
);


    parameter MSB_SLOT = 5;
    parameter ADDRSIZE = 5;
    parameter DSIZE = 1<<MSB_SLOT;
    parameter DEPTH = 1<<ADDRSIZE;



    reg [DEPTH-1:0] fifo_ff [DSIZE-1:0]; 
    reg [MSB_SLOT:0] write_ptr_ff,read_ptr_ff, next_write_ptr, next_read_ptr,fifo_ocup;

    always@*begin
        next_read_ptr = read_ptr_ff;
        next_write_ptr = write_ptr_ff;

        empty = (write_ptr_ff == read_ptr_ff);
        full = (write_ptr_ff[MSB_SLOT-1:0] == read_ptr_ff[MSB_SLOT-1:0] ) 
            && (write_ptr_ff[MSB_SLOT]!= read_ptr_ff[MSB_SLOT]);
                
        data_out = empty ? 0 : fifo_ff[read_ptr_ff[MSB_SLOT-1:0]];
        
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
            for (i = 0; i < 32; i = i + 1)
            begin
                fifo_ff[i] <= 0;       // Write zero to all registers
            end
        end
        else begin
            write_ptr_ff <= next_write_ptr;
            read_ptr_ff <= next_read_ptr;
            if (write_en && ~full)
                fifo_ff[write_ptr_ff[MSB_SLOT-1:0]] <= data_in;
        end
    end
endmodule