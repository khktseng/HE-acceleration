`include "./single_switch_stage.sv"

module switch_top (clk, rst, ctrl, input_elements, output_elements, in_val, out_val);
	parameter DATA_WIDTH = 64;
	parameter NUM_MG = 8;
	parameter NUM_PE = NUM_MG;
	

	localparam CHUNK_WIDTH = NUM_MG / NUM_PE * DATA_WIDTH;

	input clk, rst, ctrl;
	input logic [CHUNK_WIDTH-1:0] input_elements [0:NUM_PE-1][0:NUM_PE-1];
	output logic [CHUNK_WIDTH-1:0] output_elements [0:NUM_PE-1][0:NUM_PE-1];

	input logic in_val;
	output logic out_val;

	logic [0:NUM_MG-1] valid_regs ;

	assign out_val = valid_regs[NUM_MG-1];

	genvar i, j, k;
	generate
		for (i = 0; i < NUM_MG - 1; i = i + 1) begin : ss_row
			for (j = 0; j < NUM_PE; j = j + 1) begin : ss_col
				logic [CHUNK_WIDTH-1:0] in_e_down [0:NUM_PE-1];
				logic [CHUNK_WIDTH-1:0] in_e_across [0:NUM_PE-1];
				logic [CHUNK_WIDTH-1:0] out_elements [0:NUM_PE-1];

				single_switch_stage #(DATA_WIDTH, NUM_PE, NUM_MG, i, j)
					ss
					(
						.clk(clk),
						.out_elements(out_elements),
						.rst(rst),
						.ctrl(ctrl),
                        .in_elements_down(in_e_down),
                        .in_elements_across(in_e_across)
                        
                     );
			end
		end

		for (i = 0; i < NUM_MG - 1; i  = i + 1) begin : ss_in_row
			for (j = 0; j < NUM_PE; j = j + 1) begin : ss_in_col
				if (i == 0) begin
					for (k = 0; k < NUM_PE; k = k + 1) begin
						assign ss_row[i].ss_col[j].in_e_down[k] = input_elements[j][k];
						assign ss_row[i].ss_col[j].in_e_across[k] = input_elements[(j+1)%NUM_PE][k];
					end
				end else begin
					for (k = 0; k < NUM_PE; k = k + 1) begin
						assign ss_row[i].ss_col[j].in_e_down[k] = ss_row[i-1].ss_col[j].out_elements[k];
						assign ss_row[i].ss_col[j].in_e_across[k] = ss_row[i-1].ss_col[(j+1)%NUM_PE].out_elements[k];
					end
				end
			end
		end
	endgenerate

	generate
		for (j = 0; j < NUM_PE; j = j + 1) begin : ss_out_row
			for (k = 0; k < NUM_PE; k = k + 1) begin : ss_out_col
				always_ff @(posedge clk) begin
					if (ctrl) begin // transpose
						output_elements[j][k] <= ss_row[NUM_MG-2].ss_col[j].out_elements[k];
					end else if (rst) begin
						output_elements[j][k] <= 0;
					end else begin
						output_elements[j][k] <= input_elements[j][k];
					end
				end
			end
		end
	endgenerate

	always @(posedge clk) begin
		if (rst) begin
			valid_regs <= 0;
		end else begin
			valid_regs <= (valid_regs << 1) + in_val;
		end
	end
endmodule
