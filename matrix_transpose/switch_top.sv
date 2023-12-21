`include "./single_switch_stage.sv"

module switch_top (clk, rst, ctrl, input_elements, output_elements);
	parameter DATA_WIDTH = 64;
	parameter NUM_PE = 8;
	parameter NUM_MG = 8;

	localparam CHUNK_WIDTH = NUM_MG / NUM_PE * DATA_WIDTH;

	input clk, rst, ctrl;
	input logic [CHUNK_WIDTH-1:0] input_elements [0:NUM_PE-1][0:NUM_PE-1];
	output logic [CHUNK_WIDTH-1:0] output_elements [0:NUM_PE-1][0:NUM_PE-1];

	// [row][col][idx]
	logic [CHUNK_WIDTH-1:0] outputs [0:NUM_MG-1][0:NUM_PE-1][0:NUM_PE-1];

	genvar i, j, k;
	generate
		for(j = 0; j < NUM_PE; j = j + 1) begin
			for (k = 0; k < NUM_PE; k = k + 1) begin
				assign outputs[0][j][k] = input_elements[j][k];
			end
		end

		for (i = 0; i < NUM_MG - 1; i = i + 1) begin
			for (j = 0; j < NUM_PE; j = j + 1) begin
				logic [CHUNK_WIDTH-1:0] in_e_down [0:NUM_PE-1];
				logic [CHUNK_WIDTH-1:0] in_e_across [0:NUM_PE-1];
				logic [CHUNK_WIDTH-1:0] out_e [0:NUM_PE-1];

				for (k = 0; k < NUM_PE; k = k + 1) begin
					assign in_e_down[k] = outputs[i][j][k];
					assign in_e_across[k] = outputs[i][(j+1)%NUM_PE][k];
					assign outputs[i+1][j][k] = out_e[k];
				end

				single_switch_stage #(DATA_WIDTH, NUM_PE, NUM_MG, i, j)
					ss(clk, rst, ctrl, in_e_down, in_e_across, out_e);
			end
		end
	endgenerate

	generate
		for (j = 0; j < NUM_PE; j = j + 1) begin
			for (k = 0; k < NUM_PE; k = k + 1) begin
				always_ff @(posedge clk) begin
					if (ctrl) begin // transpose
						output_elements[j][k] <= outputs[NUM_MG-1][j][k];
					end else if (rst) begin
						output_elements[j][k] <= 0;
					end else begin
						output_elements[j][k] <= input_elements[j][k];
					end
				end
			end
		end
	endgenerate
endmodule