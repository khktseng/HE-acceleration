`ifndef MATRIX_TRANSPOSE_MEMORY_SV
`define MATRIX_TRANSPOSE_MEMROY_SV

`include "./transpose_memory_bank.sv"
`include "mtm_unit.sv"

module matrix_transpose_memory
#(
    parameter DATA_WIDTH = 64,
    parameter NUM_MG = 8,
    parameter NUM_PE = NUM_MG
)(
    input clk,
    input rst,
    input ctrl,
    input in_val,
    output out_val,
    input logic [DATA_WIDTH-1:0] input_elements [0:NUM_MG-1][0:NUM_PE-1],
    output logic [DATA_WIDTH-1:0] output_elements [0:NUM_MG-1][0:NUM_PE-1]
);
    localparam ADDR_WIDTH = $clog2(NUM_PE);

    logic wen;
    logic [ADDR_WIDTH-1:0] write_addr;
    logic [ADDR_WIDTH-1:0] read_addr[0:NUM_MG-1];

    logic [DATA_WIDTH-1:0] write_data [0:NUM_MG-1];
    logic [DATA_WIDTH-1:0] read_data [0:NUM_MG-1];

    genvar i;
    generate
        for (i = 0; i < NUM_MG; i = i + 1) begin : memory_banks
		mtm_unit #(
			.DATA_WIDTH(DATA_WIDTH),
			.NUM_PE(NUM_PE)
        ) mtm_unit_inst (
			.clk(clk),
			.rst(rst),
			.val(in_val),
			.input_row(input_elements[i]),
			.out_val(out_val),
			.output_row(output_elements[i])
            );
        end
    endgenerate

endmodule

`endif
