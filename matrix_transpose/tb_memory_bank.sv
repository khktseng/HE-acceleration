`define DATA_WIDTH 16
`define ADDR_WIDTH 3
`define NUM_PE 4

`include "transpose_memory_bank.sv"

module tb_memory_bank();
	logic clk;
	logic rst;
	logic wen;

	logic [`ADDR_WIDTH-1:0] write_addr [0:`NUM_PE-1];
	logic [`ADDR_WIDTH-1:0] read_addr [0:`NUM_PE-1];
	logic [`DATA_WIDTH-1:0] write_data [0:`NUM_PE-1];
	logic [`DATA_WIDTH-1:0] read_data [0:`NUM_PE-1];

	logic ren;

	transpose_memory_bank #(
		.DATA_WIDTH(`DATA_WIDTH),
		.NUM_PE(`NUM_PE),
		.ADDR_WIDTH(`ADDR_WIDTH)
	) DUT (
		.clk(clk),
		.rst(rst),
		.wen(wen),
		.write_addr(write_addr),
		.write_data(write_data),
		.ren(ren),
		.read_addr(read_addr),
		.read_data(read_data)
	);

	logic [`DATA_WIDTH-1:0] w0, w1, w2, w3;
	logic [`DATA_WIDTH-1:0] r0, r1, r2, r3;

	assign w0 = write_data[0];
	assign w1 = write_data[1];
	assign w2 = write_data[2];
	assign w3 = write_data[3];

	assign r0 = read_data[0];
	assign r1 = read_data[1];
	assign r2 = read_data[2];
	assign r3 = read_data[3];

	always #5 clk = ~clk;
	initial clk = 1;

	integer i;
	initial begin
		rst = 1;
		wen = 0;
		ren = 0;

		for (i = 0; i < `NUM_PE; i = i + 1) begin
			write_addr[i] = 0;
			write_data[i] = i + 1;
			read_addr[i] = 0;
		end

		#15;

		rst = 0;

		#10;

		wen = 1;
		ren = 1;

		#10;

		wen = 0;

		#100;

		$finish;
	end
endmodule

