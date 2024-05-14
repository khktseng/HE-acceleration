`ifndef MATRIX_TRANSPOSE_TOP_WRAPPER_SV
`define MATRIX_TRANSPOSE_TOP_WRAPPER_SV

`include "matrix_transpose_top.sv"
`include "butterfly_network.sv"

module matrix_transpose_top_wrapper
#(
    parameter TRANSPOSE_TYPE = 2,
    parameter DATA_WIDTH = 64,
    parameter NUM_MG = 16,
    parameter NUM_PE = NUM_MG,
    parameter ARR_SIZE = 16,
    parameter ADDR_WIDTH = 64,
    parameter CHUNK_SIZE = 16,

    localparam NUM_INPUTS = NUM_MG * NUM_PE,
    localparam NUM_STAGES = $clog2(NUM_MG * NUM_PE),
    localparam NUM_SWITCHES = NUM_INPUTS / 2
)(
    input logic clk,
    input logic rst,
    input logic ctrl,
    input logic [DATA_WIDTH-1:0] input_e,
    output logic [DATA_WIDTH-1:0] output_e,

    input logic in_val,
    output logic out_val,

    input logic [NUM_SWITCHES-1:0] butterfly_ctrl [0:NUM_STAGES-1],

    input logic [$clog2(NUM_MG)-1:0] temp_out_sel_i,
    input logic [$clog2(NUM_MG)-1:0] temp_out_sel_j,
    input logic [$clog2(NUM_MG)-1:0] temp_in_sel_i,
    input logic [$clog2(NUM_MG)-1:0] temp_in_sel_j,

    input logic [ADDR_WIDTH-1:0] base_addr,
    input logic [ADDR_WIDTH-1:0] chunk_addr,
    output logic [ADDR_WIDTH-1:0] store_addr
);

    logic [DATA_WIDTH-1:0] input_elements [0:NUM_MG-1][0:NUM_PE-1];
    logic [DATA_WIDTH-1:0] output_elements [0:NUM_MG-1][0:NUM_PE-1];

    logic [DATA_WIDTH-1:0] butterfly_input [0:NUM_INPUTS-1];
    logic [DATA_WIDTH-1:0] butterfly_output [0:NUM_INPUTS-1];
    logic butterfly_out_val;

    always_ff @(posedge clk) begin
        butterfly_input[temp_in_sel_i + temp_in_sel_j * NUM_MG] <= input_e;
        output_e <= output_elements[temp_out_sel_i][temp_out_sel_j];
    end

    genvar i, j;
    generate 
        for (i = 0; i < NUM_MG; i = i + 1) begin
            for (j = 0; j < NUM_PE; j = j + 1) begin
                assign input_elements[i][j] = butterfly_output[i * NUM_MG + j];
            end
        end
    endgenerate

    butterfly_network
    #(
        .DATA_WIDTH (DATA_WIDTH),
        .NUM_INPUTS (NUM_INPUTS)
    ) bn (
        .clk (clk),
        .rst (rst),
        .in_val (in_val), 
        .out_val (butterfly_out_val),
        .input_elements (butterfly_input),
        .ctrl_arr (butterfly_ctrl),
        .output_elements (butterfly_output)
    );

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
            .in_val(butterfly_out_val),
            .input_elements(input_elements),
            .output_elements(output_elements),
            .out_val(out_val),
            
            .base_addr(base_addr),
            .chunk_addr(chunk_addr),
            .store_addr(store_addr)
        );
    

endmodule

`endif