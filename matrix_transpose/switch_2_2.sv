`ifndef SWITCH_2_2_SV
`define SWITCH_2_2_SV

module switch_2_2
#(
	parameter DATA_WIDTH = 64
)(
	input logic ctrl,	// 0 = pass through, 1 = cross
	input logic [DATA_WIDTH-1:0] input_0,
	input logic [DATA_WIDTH-1:0] input_1,
	output logic [DATA_WIDTH-1:0] output_0,
	output logic [DATA_WIDTH-1:0] output_1
);
	always_comb begin
		if (ctrl) begin
			output_0 = input_1;
			output_1 = input_0;
		end else begin
			output_0 = input_0;
			output_1 = input_1;
		end
	end
endmodule


`endif