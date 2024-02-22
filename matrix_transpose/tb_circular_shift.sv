`define DATA_WIDTH 3
`define NUM_PE 8
`define TOTAL_WIDTH `DATA_WIDTH*`NUM_PE
`define SHIFT_AMT_BITS $clog2(`TOTAL_WIDTH)

`include "circular_shift.sv"

module tb_circular_shift();
	logic [`TOTAL_WIDTH-1:0] input_bits;
    logic [`SHIFT_AMT_BITS-1:0] shift_amt_b;
	logic [`TOTAL_WIDTH-1:0] output_bits;

	logic [`DATA_WIDTH-1:0] input_row [0:`NUM_PE-1];
	logic [`DATA_WIDTH-1:0] output_row [0:`NUM_PE-1];

	circular_shift #(
		.TOTAL_WIDTH (`TOTAL_WIDTH),
		.SHIFT_DIR (1)
	) DUT (
		.input_bits(input_bits),
		.shift_amt(shift_amt_b),
		.output_bits(output_bits)
	);

	genvar i;
	generate
        for (i = 0; i < `NUM_PE; i = i + 1) begin
            assign input_bits[(i+1)*`DATA_WIDTH-1:i*`DATA_WIDTH] = input_row[i];
            assign output_row[i] = output_bits[(i+1)*`DATA_WIDTH-1:i*`DATA_WIDTH];
        end
    endgenerate

	integer j;
	integer shift_amt;
	assign shift_amt_b = shift_amt * `DATA_WIDTH;
	initial begin
		for (j = 0; j < `NUM_PE; j = j + 1) begin
			input_row[j] = j;
		end

		shift_amt = 0;

		#10;

		shift_amt = 5 ;

		#10;
		
		shift_amt = 7;

		#10;
		$finish;
	end
endmodule