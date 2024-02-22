`ifndef MTM_UNIT_SV
`define MTM_UNIT_SV

`include "transpose_memory_bank.sv"
`include "memory_ctrl.sv"
`include "c"

module mtm_unit #(
	parameter DATA_WIDTH = 64,
	parameter NUM_PE = 8,
	
	parameter ADDR_WIDTH = $clog2(NUM_PE),

	localparam TOTAL_WIDTH = DATA_WIDTH * NUM_PE;
	localparam SHIFT_AMT_BITS = $clog2(TOTAL_WIDTH)
)(
	input logic clk,
	input logic rst,

	input logic [DATA_WIDTH-1:0] input_row [0:NUM_PE-1],

	output logic [DATA_WIDTH-1:0] output_row [0:NUM_PE-1]
);
	logic wen;
	logic [ADDR_WIDTH-1:0] write_addr [0:NUM_PE-1];
	logic [DATA_WIDTH-1:0] write_data [0:NUM_PE-1];

	logic ren;
    logic [ADDR_WIDTH-1:0] read_addr [0:NUM_PE-1];
    logic [DATA_WIDTH-1:0] read_data [0:NUM_PE-1];

	logic [TOTAL_WIDTH-1:0] in_shift_input;
    logic [SHIFT_AMT_BITS-1:0] in_shift_amt;
    logic [TOTAL_WIDTH-1:0] in_shift_output;

	logic [TOTAL_WIDTH-1:0] out_shift_input;
    logic [SHIFT_AMT_BITS-1:0] out_shift_amt;
    logic [TOTAL_WIDTH-1:0] out_shift_output;

	assign in_shift_input = input_row;
	assign write_data = in_shift_output;

	assign out_shift_input = read_data;
	assign output_row = out_shift_output;

	circular_shift #(
		.TOTAL_WIDTH (TOTAL_WIDTH),
		.SHIFT_AMT_BITS (SHIFT_AMT_BITS),
		.SHIFT_DIR (1)
	) circular_shift_inst_in (
		.input_row (in_shift_input),
		.shift_amt (in_shift_amt),
		.output_row (in_shift_output)
	);

	circular_shift #(
		.TOTAL_WIDTH (TOTAL_WIDTH),
		.SHIFT_AMT_BITS (SHIFT_AMT_BITS),
		.SHIFT_DIR (0)
	) circular_shift_inst_out (
		.input_row (out_shift_input),
		.shift_amt (out_shift_amt),
		.output_row (out_shift_output)
	);

	transpose_memory_bank #(
		.DATA_WIDTH (DATA_WIDTH),
		.NUM_PE (NUM_PE),
		.ADDR_WIDTH (ADDR_WIDTH)
	) bank0 (
		.clk (clk),
		.rst (rst),
		.wen (wen),
		.write_addr (write_addr),
		.write_data (write_data),
		.ren (ren),
		.read_addr (read_addr),
		.read_data (read_data)
	);

	memory_ctrl #(

	) memory_ctrl_inst (

	);
	

endmodule

`endif