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

*/

module input_router(
    input wire clk, 
    input wire reset,
    input wire [63:0] flit,
    input wire [2:0] port,
    input wire [15:0] router_x,
    input wire [15:0] router_y,
    output reg [2:0] vc_select
);

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
    
    `define HEAD 2'b11
    
    wire [15:0] dest_x,dest_y;
    
    assign dest_x = flit[63:48]; 
    assign dest_y = flit[47:32]; 


    // XY algorithm 
    // First send in X direction 
    // Then Y direction
    always @ (*)begin
        // if ( flit[1:0] == `HEAD  )begin
            if (dest_x == router_x && dest_y == router_y)begin
                vc_select = `L;
            end
            else if (dest_x == router_x)begin
                if(dest_y < router_y)begin
                    vc_select = `N;
                end
                else begin
                    vc_select = `S;
                end
            end
            else begin
                if(dest_x > router_x)begin
                    vc_select = `E;
                end
                else begin
                    vc_select = `W;
                end
            end

            // check if this works to avoid packets be sending back to source 
            if(vc_select == port )
                vc_select = `INVALID;
        // end
    end

    // // YX algorithm 
    // // First y direction 
    // // Then x direction 
    // always @ (*)begin
    //     // if ( flit[1:0] == `HEAD  )begin
    //         if (dest_x == router_x && dest_y == router_y)begin
    //             vc_select = `L;
    //         end
    //         else if (dest_y == router_y)begin
    //             if(dest_x < router_x)begin
    //                 vc_select = `W;
    //             end
    //             else begin
    //                 vc_select = `E;
    //             end
    //         end
    //         else begin
    //             if(dest_y > router_y)begin
    //                 vc_select = `S;
    //             end
    //             else begin
    //                 vc_select = `N;
    //             end
    //         end

    //         if(vc_select == port )
    //             vc_select = `INVALID;
    //     // end
    // end

endmodule