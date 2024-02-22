module memory_ctrl #(
	parameter DATA_WIDTH = 64,
	parameter NUM_PE = 8,
	parameter ADDR_WIDTH = $clog2(NUM_PE),
	parameter SHIFT_AMT_BITS = 9 // $clog2(DATA_WIDTH * NUM_PE)
)(
	input clk,
	input rst,

	input val,
	output logic wen,
	output logic [ADDR_WIDTH:0] write_addr [0:NUM_PE-1],

	output logic out_val,
	output logic ren,
	output logic [ADDR_WIDTH:0] read_addr [0:NUM_PE-1],

	output logic [SHIFT_AMT_BITS-1:0] in_shift_amt,
	output logic [SHIFT_AMT_BITS-1:0] out_shift_amt
);
	logic bank_sel;	// selects bank to write to
	logic [1:0] bank_val;

	logic [ADDR_WIDTH-1:0] write_row_num;
	
	assign wen = val;
	assign out_val = bank_val[~bank_sel];

	genvar i;
	generate
		for (i = 0; i < NUM_PE; i = i + 1) begin
			assign write_addr[i] = {bank_sel, write_row_num};
			assign read_addr[i] = {~bank_sel, write_row_num - i};
		end
	endgenerate

	always_ff @(posedge clk) begin
		if (rst) begin
			write_row_num <= 'b0;
			bank_sel <= 'b0;
			bank_val <= 2'b0;
		end else begin
			if (wen) begin
				if (write_row_num < NUM_PE - 1) begin
					write_row_num <= write_row_num + 'b1;
				end else begin
					write_row_num <= 'b0;
					bank_val[bank_sel] <= 1'b1;
					bank_val[~bank_sel] <= 1'b0;
					bank_sel <= ~bank_sel;
				end
			end
		end
	end
endmodule
