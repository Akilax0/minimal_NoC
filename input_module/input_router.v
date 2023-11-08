/*

File: input_router.v
Descripton: input router module that does the route calculation 

Only does below if head flit

Here the route algorithm calculates 
the VC buffer the cosidered flit should be passed to 

The VC buffers here are used as 
buffers for the four directions 

*/

module input_router(
    input wire clk, 
    input wire reset,
    
    input wire [7:0] flit;
    output wire [1:0] vc_select;

);






    


endmodule