`timescale 1ns/1ns

`include "mtm_unit.sv"

`define DATA_WIDTH 8
`define NUM_PE 4

module tb_mtm_unit();
	logic clk;
	logic rst;

	logic val;
	logic [`DATA_WIDTH-1:0] input_row [0:`NUM_PE-1];
	
	logic out_val;
	logic [`DATA_WIDTH-1:0] output_row [0:`NUM_PE-1];

	logic [`DATA_WIDTH-1:0] input_matrix0 [0:`NUM_PE-1][0:`NUM_PE-1];
	logic [`DATA_WIDTH-1:0] input_matrix1 [0:`NUM_PE-1][0:`NUM_PE-1];

	mtm_unit #(
		.DATA_WIDTH (`DATA_WIDTH),
		.NUM_PE (`NUM_PE)
	) DUT (
		.clk (clk),
		.rst (rst),
		.val (val),
		.input_row (input_row),
		.out_val (out_val),
		.output_row (output_row)
	);

	always #5 clk = ~clk;
	initial clk = 1;

	integer i, j;
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;

		for (i = 0; i < 4; i = i + 1) begin
			for (j = 0; j < 4; j = j + 1) begin
				input_matrix0[i][j] = 8'h10 * i + 8'h0A + j;
				input_matrix1[i][j] = 8'h0;
			end
		end
	end

	initial begin
		rst = 1;
		val = 0;
		input_row = input_matrix0[0];
		
		#10;

		rst = 0;
		val = 1;

		#10;

		input_row = input_matrix0[1]; #10;
		input_row = input_matrix0[2]; #10;
		input_row = input_matrix0[3]; #10;

		val = 0;
		input_row = input_matrix1[0]; #10;

		#10;
		#100;


		$finish;
	end

endmodule
