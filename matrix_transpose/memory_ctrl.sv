module memory_ctrl #(
	parameter DATA_WIDTH = 64,
	parameter BLOCK_SIZE = 8
	parameter BANK_ADDR_WIDTH = $clog2(BLOCK_SIZE)
)(
	input clk,
	input rst,

	input ctrl

	input val,
	output ren,
	output 
)

endmodule
