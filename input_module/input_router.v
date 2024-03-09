/*

File: input_router.v
Descripton: input router module that does the route calculation 

Only does below if head flit

Here the route algorithm calculates 
the VC buffer the cosidered flit should be passed to 

The VC buffers here are used as 
buffers for the four directions 

Compare with x and y position of the contained router
port is inputted to be ignored


DOES NOT ACCOUNT FOR SAME PORT JUST YET -> Now it happens!! gives out invalid 
both xy and yx tested

The PORT , ROUTER_X, ROUTER_Y, akgorithm is set as parameters for the input router
For each data_in check dest_x and dest_y to find vc_select

*/

module input_router(
    input wire clk, 
    input wire reset,
    input wire [DSIZE-1:0] data_in,

    output reg [2:0] vc_select
);

    parameter MSB_SLOT = 5;
    parameter DSIZE = 1<<MSB_SLOT;
    parameter RRSIZE = 1<<MSB_SLOT-2;
    // xy - 1'b0
    // yx - 1'b1 
    parameter algorithm = 1'b0;
    parameter  [2:0] PORT = 0; 
    parameter  [RRSIZE-1:0] ROUTER_X = 0;
    parameter  [RRSIZE-1:0] ROUTER_Y = 0;




    // Use the flit format if needed later on -> currently going for packet based switching
    // Flit format
    //  0 0 0 0 0 0 B1 B0
    // 11 - Head flit
    // 01 - Body flit
    // 10 - Tail flit

    `define N 3'b000
    `define S 3'b001
    `define E 3'b010
    `define W 3'b011
    `define L 3'b100
    `define INVALID 3'b111
    
    wire [RRSIZE-1:0] dest_x,dest_y;
    
    assign dest_x = data_in[DSIZE-1:DSIZE-RRSIZE]; 
    assign dest_y = data_in[DSIZE-RRSIZE-1:DSIZE-RRSIZE-RRSIZE]; 

    always @ (*)begin
        if ( algorithm == 1'b0 )begin
        // XY algorithm 
        // First send in X direction 
        // Then Y direction
            if (dest_x == ROUTER_X && dest_y == ROUTER_Y)begin
                vc_select = `L;
            end
            else if (dest_x == ROUTER_X)begin
                if(dest_y < ROUTER_Y)begin
                    vc_select = `N;
                end
                else begin
                    vc_select = `S;
                end
            end
            else begin
                if(dest_x > ROUTER_X)begin
                    vc_select = `E;
                end
                else begin
                    vc_select = `W;
                end
            end

            // check if this works to avoid packets be sending back to source 
            if(vc_select == PORT )
                vc_select = `INVALID;
        end
        else begin

            // YX algorithm 
            // First y direction 
            // Then x direction 
            if (dest_x == ROUTER_X && dest_y == ROUTER_Y)begin
                vc_select = `L;
            end
            else if (dest_y == ROUTER_Y)begin
                if(dest_x < ROUTER_X)begin
                    vc_select = `W;
                end
                else begin
                    vc_select = `E;
                end
            end
            else begin
                if(dest_y > ROUTER_Y)begin
                    vc_select = `S;
                end
                else begin
                    vc_select = `N;
                end
            end

            if(vc_select == PORT )
                vc_select = `INVALID;
                
        end
    end


endmodule