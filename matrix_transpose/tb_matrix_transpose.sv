`timescale 1ns/1ns
//`include "./matrix_transpose_single.sv"
`include "./switch_top.sv"

module tb_matrix_transpose;
	logic clk, rst, ctrl;

	logic in_val, out_val;

	logic [7:0] input_matrix [0:3][0:3];
	wire [7:0] output_matrix [0:3][0:3];

	switch_top #(8, 4, 4) DUT(clk, rst, ctrl, input_matrix, output_matrix, in_val,  out_val);

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
		in_val = 0;

		#5;

		$display("Input Matrix: ");
		for (i = 0; i < 4; i = i + 1) begin
			for (j = 0; j < 4; j = j + 1) begin
				$write("%h, ", DUT.input_elements[i][j]);
			end
			$display();
		end

		rst = 0;
		in_val = 1;

		#50;

		$display("Output Matrix: ");
		for (i = 0; i < 4; i = i + 1) begin
			for (j = 0; j < 4; j = j + 1) begin
				$write("%h, ", DUT.output_elements[i][j]);
			end
			$display();
		end
		$display();

/*
		$display("row 0 inputs down");
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[0].ss.in_elements_down[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[1].ss.in_elements_down[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[2].ss.in_elements_down[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[3].ss.in_elements_down[i]);
		end $display();
		$display();

		$display("row 0 inputs across");
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[0].ss.in_elements_across[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[1].ss.in_elements_across[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[2].ss.in_elements_across[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[3].ss.in_elements_across[i]);
		end $display();
		$display();

		$display("row 0 outputs");
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[0].ss.out_elements[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[1].ss.out_elements[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[2].ss.out_elements[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[3].ss.out_elements[i]);
		end $display();
		$display();

		$display("row 0 out_elements");
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[0].out_elements[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[1].out_elements[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[2].out_elements[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[3].out_elements[i]);
		end $display();
		$display();

		$display("row 0 in_e_down");
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[0].in_e_down[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[1].in_e_down[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[2].in_e_down[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[0].g_in_j[3].in_e_down[i]);
		end $display();
		$display();

		$display("row 1 inputs down");
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[0].ss.in_elements_down[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[1].ss.in_elements_down[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[2].ss.in_elements_down[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[3].ss.in_elements_down[i]);
		end $display();
		$display();

		$display("row 1 inputs across");
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[0].ss.in_elements_across[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[1].ss.in_elements_across[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[2].ss.in_elements_across[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[3].ss.in_elements_across[i]);
		end $display();
		$display();

		$display("row 1 outputs");
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[0].ss.out_elements[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[1].ss.out_elements[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[2].ss.out_elements[i]);
		end $display();
		for (i = 0; i < 4; i = i + 1) begin
            $write("%h, ", DUT.g_in_i[1].g_in_j[3].ss.out_elements[i]);
		end $display();
		$display(); */
	

/*
		$display("###################################");
		$display();
		for(k = 0; k < 4; k = k + 1) begin
			$display("row %0d Matrix: ", k);
			for (i = 0; i < 4; i = i + 1) begin
				for (j = 0; j < 4; j = j + 1) begin
					$write("%h, ", DUT.outputs[k][i][j]);
				end
				$display();
			end
			$display();
		end */

		$display("out_val = %0d", out_val);
		$finish;
	end
endmodule