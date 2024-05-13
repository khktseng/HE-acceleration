`ifndef BUTTERFLY_NETWORK_SV
`define BUTTERFLY_NETWORK_SV

module butterfly_network #(
	parameter DATA_WIDTH = 64,
	parameter NUM_INPUTS = 16,

	localparam NUM_STAGES = $clog2(NUM_INPUTS),
	localparam NUM_SWITCHES = NUM_INPUTS / 2
)(
	input logic clk,
	input logic rst,

	input logic in_val,
	output logic out_val,

	input logic [DATA_WIDTH-1:0] input_elements [0:NUM_INPUTS-1],
	input logic [NUM_SWITCHES-1:0] ctrl_arr [0:NUM_STAGES-1],

	output logic [DATA_WIDTH-1:0] output_elements [0:NUM_INPUTS-1]
);
	logic [DATA_WIDTH-1:0] stage_connects [0:NUM_INPUTS-1][0:NUM_STAGES];
	logic [NUM_STAGES:0] valid_signals;

	assign valid_signals[0] = in_val;
	assign out_val = valid_signals[NUM_STAGES];

	genvar i, j;
	generate
		for (j = 0; j < NUM_INPUTS; j = j + 1) begin
			assign stage_connects[j][0] = input_elements[j];
			assign output_elements[j] = stage_connects[j][NUM_STAGES];
		end
	endgenerate

	generate 
		for (i = 0; i < NUM_STAGES; i = i + 1) begin
			logic [DATA_WIDTH-1:0] stage_in [0:NUM_INPUTS-1];
			logic [DATA_WIDTH-1:0] stage_out [0:NUM_INPUTS-1];

			for (j = 0; j < NUM_INPUTS; j = j + 1) begin
				assign stage_in[j] = stage_connects[j][i];
				assign stage_connects[j][i+1] = stage_out[j];
			end

			butterfly_stage #(
				.DATA_WIDTH(DATA_WIDTH),
				.NUM_INPUTS(NUM_INPUTS)
			) stage (
				.clk (clk),
				.rst (rst),
				.in_val (valid_signals[i]),
				.out_val (valid_signals[i+1]),
				.input_elements (stage_in),
				.ctrls (ctrl_arr[i]),
				.output_elements (stage_out)
			);
		end
	endgenerate

endmodule

`endif