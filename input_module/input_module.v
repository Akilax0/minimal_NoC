`include "input_router.v"
`include "utils/vc_buffer.v"

module input_module(
    input wire clk, 
    input wire reset, 


);



    

    vc_buffer vc_N(
        clk,
        reset,
        write_en,
        read_en,
        data_in,
        data_out,
        error,
        full,
        empty,
        ocup
    );

    vc_buffer vc_S(
        clk,
        reset,
        write_en,
        read_en,
        data_in,
        data_out,
        error,
        full,
        empty,
        ocup
    );

    vc_buffer vc_E(
        clk,
        reset,
        write_en,
        read_en,
        data_in,
        data_out,
        error,
        full,
        empty,
        ocup
    );

    vc_buffer vc_W(
        clk,
        reset,
        write_en,
        read_en,
        data_in,
        data_out,
        error,
        full,
        empty,
        ocup
    );

endmodule