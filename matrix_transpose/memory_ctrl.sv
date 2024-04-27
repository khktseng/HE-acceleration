`ifndef MEMORY_CTRL_SV
`define MEMORY_CTRL_SV

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
	output logic [ADDR_WIDTH-1:0] write_addr [0:NUM_PE-1],

	output logic out_val,
	output logic ren,
	output logic [ADDR_WIDTH-1:0] read_addr [0:NUM_PE-1],

	output logic [SHIFT_AMT_BITS-1:0] in_shift_amt,
	output logic [SHIFT_AMT_BITS-1:0] out_shift_amt
);
	enum {READ, IDLE} ps; // IDLE necessary to finish write

	logic bank_sel;	// selects bank to write to
	logic [1:0] bank_val;

	logic [ADDR_WIDTH-2:0] write_row_num;
	logic [ADDR_WIDTH-2:0] read_row_start;
	
	assign wen = val && ps == READ;
	assign ren = 'b1;

	genvar i;
	generate
		for (i = 0; i < NUM_PE; i = i + 1) begin
			assign write_addr[i] = {bank_sel, write_row_num};
			assign read_addr[i] = {~bank_sel, read_row_start + i[ADDR_WIDTH-2:0]};
		end
	endgenerate

	always_ff @(posedge clk) begin
		if (rst) begin
			write_row_num <= 'b0;
			read_row_start <= 'b0;
			bank_sel <= 'b0;
			bank_val <= 2'b0;
			in_shift_amt <= 'b0;
			out_shift_amt <= 'b0;
			out_val <= 'b0;
		end else begin
			case (ps)
				IDLE: begin
					bank_sel <= ~bank_sel;
					ps <= READ;
					write_row_num <= 'b0;
					read_row_start <= 'b0;
					in_shift_amt <= 'b0;
					out_shift_amt <= 'b0 - DATA_WIDTH;
					out_val <= 'b0;
				end
				READ: begin
					if (wen) begin
						if (write_row_num < NUM_PE - 1) begin
							write_row_num <= write_row_num + 'b1;
							in_shift_amt <= in_shift_amt + DATA_WIDTH;
						end else begin
							bank_val[bank_sel] <= 1'b1;
							ps <= IDLE;
						end
					end

					if (ren) begin
						out_shift_amt <= out_shift_amt + DATA_WIDTH;
						out_val <= bank_val[~bank_sel];
						if (read_row_start != 'b1) begin
							read_row_start <= read_row_start - 'b1;
						end else begin
							bank_val[~bank_sel] <= 1'b0;
						end
					end
				end
			endcase
		end
	end
endmodule
`endif