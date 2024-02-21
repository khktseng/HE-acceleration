module memory_block #(
	parameter DATA_WIDTH = 64,
	parameter NUM_MG = 8,
	
	localparam ADDR_WIDTH = $clog2(NUM_MG)
)(
	input clk,
	input rst,

	input wen,
	input [ADDR_WIDTH-1:0] waddr [0:NUM_MG-1],
	input [DATA_WIDTH-1:0] write_elements [0:NUM_MG-1],

	input ren,
	input [ADDR_WIDTH-1:0] raddr [0:NUM_MG-1],
	output [DATA_WIDTH-1:0] read_elements [0:NUM_MG-1]
);
	always_ff @(posedge clk) begin
		if (rst) begin
		end
	end
endmodule

