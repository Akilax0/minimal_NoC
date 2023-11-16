`include "input_module/input_module.v"
`include "output_module/output_module.v"
`include "router.v"
`include "ni/pkt_proc.v"
`include "ni/cdc_pkt.v"
`include "ni/ni.v"

module router_wrapper(
    input wire clk,
    input wire reset,

);


// router connect input / output modules for 5 directions




// input modules
input_module input_module_N(clk, reset, data_in, read_en, write_en,data_out);

// output modules
output_module_N output_module_N(clk, reset, data_in, read_en, write_en,data_out);


// router
router router();