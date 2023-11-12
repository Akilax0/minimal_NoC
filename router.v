`include "utils/mux_4to1_8bit.v"

module router (
    input wire clk,
    input wire reset,
    
    input wire N_data_in [7:0];
    input wire S_data_in [7:0];
    input wire E_data_in [7:0];
    input wire W_data_in [7:0];
    input wire L_data_in [7:0];
    
    input wire sel [4:0];

    output wire N_data_out [7:0];
    output wire S_data_out [7:0];
    output wire E_data_out [7:0];
    output wire W_data_out [7:0];
    output wire L_data_out [7:0];
    
);


    mux_4to1_8bit crossbar_N(N_data_in, S_data_in, E_data_in, W_data_in, L_data_in, sel, N_data_out);
    mux_4to1_8bit crossbar_S(N_data_in, S_data_in, E_data_in, W_data_in, L_data_in, sel, S_data_out);
    mux_4to1_8bit crossbar_E(N_data_in, S_data_in, E_data_in, W_data_in, L_data_in, sel, E_data_out);
    mux_4to1_8bit crossbar_W(N_data_in, S_data_in, E_data_in, W_data_in, L_data_in, sel, W_data_out);
    mux_4to1_8bit crossbar_L(N_data_in, S_data_in, E_data_in, W_data_in, L_data_in, sel, L_data_out);

    // Internal crossbar connections
    logic [3:0] crossbar_out [0:3];

    // Implementing a 4x4 crossbar switch using assign statements
    assign crossbar_out = {in_sel[0], in_sel[1], in_sel[2], in_sel[3]};

    // Connecting outputs to the crossbar outputs
    always_ff @(posedge clk) begin
        for (int i = 0; i < 4; i = i + 1) begin
            out_data[i] <= (in_valid[crossbar_out[i]]) ? in_data[crossbar_out[i]] : 0;
            out_valid[i] <= in_valid[crossbar_out[i]];
        end
    end

endmodule
