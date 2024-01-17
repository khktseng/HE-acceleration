`ifndef MATRIX_TRANSPOSE_TOP_WRAPPER_SV
`define MATRIX_TRANSPOSE_TOP_WRAPPER_SV

`include "matrix_transpose_top.sv"

module matrix_transpose_top_wrapper
#(
    parameter TRANSPOSE_TYPE = 1,
    parameter DATA_WIDTH = 64,
    parameter NUM_MG = 64,
    parameter NUM_PE = NUM_MG,
    parameter ARR_SIZE = 64,
    parameter ADDR_WIDTH = 64,
    parameter CHUNK_SIZE = 64
)(
    input logic clk,
    input logic rst,
    input logic ctrl,
    input logic [DATA_WIDTH-1:0] input_e,
    output logic [DATA_WIDTH-1:0] output_e,

    input logic [$clog2(NUM_MG)-1:0] temp_out_sel_i,
    input logic [$clog2(NUM_MG)-1:0] temp_out_sel_j,
    input logic [$clog2(NUM_MG)-1:0] temp_in_sel_i,
    input logic [$clog2(NUM_MG)-1:0] temp_in_sel_j
);

    logic [DATA_WIDTH-1:0] input_elements [0:NUM_MG-1][0:NUM_PE-1];
    logic [DATA_WIDTH-1:0] output_elements [0:NUM_MG-1][0:NUM_PE-1];
    logic out_val;
    logic [ADDR_WIDTH-1:0] store_addr;

    integer i;
    always_comb begin
        input_elements[temp_in_sel_i][temp_in_sel_j] = input_e;
        output_e = output_elements[temp_out_sel_i][temp_out_sel_j];
    end

    matrix_transpose_top
        #(
            .TRANSPOSE_TYPE(TRANSPOSE_TYPE),
            .DATA_WIDTH(DATA_WIDTH),
            .NUM_MG(NUM_MG),
            .ARR_SIZE(ARR_SIZE),
            .ADDR_WIDTH(ADDR_WIDTH),
            .CHUNK_SIZE(CHUNK_SIZE)
        ) mtt (
            .clk(clk),
            .rst(rst),
            .ctrl(ctrl),
            .in_val(0),
            .input_elements(input_elements),
            .output_elements(output_elements),
            .out_val(out_val),
            
            .base_addr(0),
            .chunk_addr(0),
            .store_addr(store_addr)
        );
    

endmodule

`endif