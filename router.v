`include "utils/mux_5to1_64bit.v"

module router (
    input wire clk,
    input wire reset,
    
    input wire N_data_in [63:0];
    input wire S_data_in [63:0];
    input wire E_data_in [63:0];
    input wire W_data_in [63:0];
    input wire L_data_in [63:0];
    
    input wire sel_N [4:0];
    input wire sel_S [4:0];
    input wire sel_E [4:0];
    input wire sel_W [4:0];
    input wire sel_L [4:0];

    output wire N_data_out [63:0];
    output wire S_data_out [63:0];
    output wire E_data_out [63:0];
    output wire W_data_out [63:0];
    output wire L_data_out [63:0];
    
);


    mux_5to1_64bit crossbar_N(N_data_in, S_data_in, E_data_in, W_data_in, L_data_in, sel_N, N_data_out);
    mux_5to1_64bit crossbar_S(N_data_in, S_data_in, E_data_in, W_data_in, L_data_in, sel_S, S_data_out);
    mux_5to1_64bit crossbar_E(N_data_in, S_data_in, E_data_in, W_data_in, L_data_in, sel_E, E_data_out);
    mux_5to1_64bit crossbar_W(N_data_in, S_data_in, E_data_in, W_data_in, L_data_in, sel_W, W_data_out);
    mux_5to1_64bit crossbar_L(N_data_in, S_data_in, E_data_in, W_data_in, L_data_in, sel_L, L_data_out);


    // // Internal crossbar connections
    // logic [3:0] crossbar_out [0:3];

    // // Implementing a 4x4 crossbar switch using assign statements
    // assign crossbar_out = {in_sel[0], in_sel[1], in_sel[2], in_sel[3]};

    // // Connecting outputs to the crossbar outputs
    // always_ff @(posedge clk) begin
    //     for (int i = 0; i < 4; i = i + 1) begin
    //         out_data[i] <= (in_valid[crossbar_out[i]]) ? in_data[crossbar_out[i]] : 0;
    //         out_valid[i] <= in_valid[crossbar_out[i]];
    //     end
    // end

endmodule
