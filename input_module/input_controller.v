/*

File:  input_controller.v
Desciption: Responsible for handling input data to the input module. 

Checks if input data is avaialable and virtual channel buffers are available
data to be read. Once the condition is verified sends read signal
to the input side data.
    
*/


module input_controller(
    input clk,
    input reset,
    input wire input_empty,
    input wire buffer_empty,
    output reg input_read
);


    always @ (*)begin
        if (input_empty == 1'b0  && buffer_empty ==1'b1)
            input_read = 1'b1;
        else
            input_read = 1'b0;
    end

endmodule