`ifndef BUTTERFLY_STAGE_SV
`define BUTTERFLY_STAGE_SV

module butterfly_stage
#(
	parameter DATA_WIDTH = 64,
	parameter NUM_INPUTS = 16,
	localparam NUM_SWITCHES = NUM_INPUTS / 2
)(
	input logic clk,
	input logic rst,

	input logic in_val,
	output logic out_val,

	input logic [DATA_WIDTH-1:0] input_elements [0:NUM_INPUTS-1],
	input logic [NUM_SWITCHES-1:0] ctrls,

	output logic [DATA_WIDTH-1:0] output_elements [0:NUM_INPUTS-1]
);

	logic [DATA_WIDTH-1:0] switch_outputs [0:NUM_INPUTS-1];

	genvar i;
	generate
		for (i = 0; i < NUM_SWITCHES; i = i + 1) begin
			switch_2_2 #(
				.DATA_WIDTH(DATA_WIDTH)
			) sw (
				.ctrl(ctrls[i]),
				.input_0(input_elements[2*i]),
				.input_1(input_elements[2*i+1]),
				.output_0(switch_outputs[2*i]),
				.output_1(switch_outputs[2*i+1])
			);
		end
	endgenerate

	always_ff @(posedge clk) begin
		output_elements <= switch_outputs;

		if (rst) begin
			out_val <= 0;
		end else begin
			out_val <= in_val;
		end
	end

endmodule
`endif