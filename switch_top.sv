`include "./single_switch_stage.sv"

module switch_top (clk, rst, ctrl, input_elements, output_elements);
	parameter DATA_WIDTH = 64;
	parameter NUM_PE = 8;
	parameter NUM_MG = 8;

	localparam CHUNK_WIDTH = NUM_MG / NUM_PE * DATA_WIDTH;

	input clk, rst, ctrl;
	input logic [CHUNK_WIDTH-1:0] input_elements [0:NUM_PE-1];
	output logic [CHUNK_WIDTH-1:0] output_elements [0:NUM_PE-1];

	logic [CHUNK_WIDTH-1:0] outputs [0:NUM_MG-1][0:NUM_PE-1][0:NUM_PE-1];

	genvar i, j;
	generate
		for (i = 0; i < NUM_MG - 1; i = i + 1) begin
			for (j = 0; j < NUM_PE; j = j + 1) begin
				single_switch_stage #(DATA_WIDTH, NUM_PE, NUM_MG, i, j)
					ss(clk, rst, ctrl, outputs[i][j], outputs[i][(j+1)%NUM_PE], outputs[i+1][j]);
			end
		end

		for (j = 0; j < NUM_PE; j = j + 1) begin
			assign output_elements[j] = outputs[NUM_MG-1][NUM_PE-1][j];
		end
	endgenerate

	integer k;
	always_ff @(posedge clk) begin
		for (k = 0; k < NUM_PE; k = k + 1) begin
			outputs[0][k] <= input_elements[k];
		end
	end
endmodule