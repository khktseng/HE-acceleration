`timescale 1ns/100ps
`include "./single_switch_stage.sv"

module tb_single_switch_stage;
	logic clk, rst, ctrl;

	logic [7:0] in_elements_down [0:3];
	logic [7:0] in_elements_across [0:3];
	wire [7:0] out_elements [0:3];

	single_switch_stage #(8,4,4,2,2) DUT(clk, rst, ctrl, in_elements_down, in_elements_across, out_elements);

	always #5 clk <= ~clk;
	initial clk = 1;

	integer i;
	initial begin
		$dumpfile("ss.vcd");
		$dumpvars(0, tb_single_switch_stage);

		for (i = 0; i < 4; i = i + 1)
			$dumpvars(0,in_elements_down[i], in_elements_across[i], out_elements[i], DUT.next_output[i]);

		rst = 1;
		ctrl = 1;

		#5

		rst = 0;

		in_elements_down[0] = 8'h0C;
		in_elements_down[1] = 8'h0B;
		in_elements_down[2] = 8'h2C;
		in_elements_down[3] = 8'h3C;

		in_elements_across[0] = 8'h0D;
		in_elements_across[1] = 8'h1D;
		in_elements_across[2] = 8'h1C;
		in_elements_across[3] = 8'h3D;

		#50;

		$finish;
	end
endmodule



