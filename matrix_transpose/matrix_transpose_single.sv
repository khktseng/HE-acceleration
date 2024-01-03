module matrix_transpose_single(clk, rst, ctrl, input_elements, output_elements);
	parameter DATA_WIDTH = 64;
	parameter NUM_MG = 8;
	parameter NUM_PE = NUM_MG;
	

	localparam CHUNK_WIDTH = NUM_MG / NUM_PE * DATA_WIDTH;

	input clk, rst, ctrl, in_val;
	input logic [CHUNK_WIDTH-1:0] input_elements [0:NUM_MG-1][0:NUM_PE-1];
	output logic [CHUNK_WIDTH-1:0] output_elements [0:NUM_MG-1][0:NUM_PE-1];
	output logic out_val;

	genvar i, j;
	generate
		for (i = 0; i < NUM_MG; i = i + 1) begin
			for (j = 0; j < NUM_PE; j = j + 1) begin
				always_ff @(posedge clk) begin
					if (ctrl) begin //transpose
						output_elements[i][j] <= input_elements[j][i];
					end else if (rst) begin
						output_elements[i][j] <= 0;
					end else begin
						output_elements[i][j] <= input_elements[i][j];
					end
				end
			end
		end
	endgenerate

	always_ff @(posedge clk) begin
		if (rst) begin
			out_val <= 0;
		end else begin
			out_val <= in_val;
		end
	end

endmodule