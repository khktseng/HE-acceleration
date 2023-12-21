`timescale 1ns/1ns
//`include "./matrix_transpose_single.sv"
`include "./switch_top.sv"

module tb_matrix_transpose;
	logic clk, rst, ctrl;

	logic [7:0] input_matrix [0:3][0:3];
	wire [7:0] output_matrix [0:3][0:3];

	switch_top #(8, 4, 4) DUT(clk, rst, ctrl, input_matrix, output_matrix);

	always #5 clk <= ~clk;
	initial clk = 1;

	integer i, j, k;
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;

		for (i = 0; i < 4; i = i + 1) begin
			for (j = 0; j < 4; j = j + 1) begin
				input_matrix[i][j] = 8'h10 * i + 8'h0A + j;
			end
		end
	end

	initial begin
		rst = 1;
		ctrl = 1;

		#5;

		$display("Input Matrix: ");
		for (i = 0; i < 4; i = i + 1) begin
			for (j = 0; j < 4; j = j + 1) begin
				$write("%h, ", DUT.input_elements[i][j]);
			end
			$display();
		end

		rst = 0;

		#50;

		$display("Output Matrix: ");
		for (i = 0; i < 4; i = i + 1) begin
			for (j = 0; j < 4; j = j + 1) begin
				$write("%h, ", DUT.output_elements[i][j]);
			end
			$display();
		end

		$finish;
	end
endmodule