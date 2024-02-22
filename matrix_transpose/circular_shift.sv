`ifndef CIRCULAR_SHIFT_SV
`define CIRCULAR_SHIFT_SV

// shifts right by shift_amt
module circular_shift #(
    parameter TOTAL_WIDTH = 512,

    parameter SHIFT_AMT_BITS = $clog2(TOTAL_WIDTH),
    parameter SHIFT_DIR = 0 // 0 = shift right. 1 = shift left
)(
    input [TOTAL_WIDTH-1:0] input_bits,
    input [SHIFT_AMT_BITS-1:0] shift_amt,
    output logic [TOTAL_WIDTH-1:0] output_bits
);
    logic [TOTAL_WIDTH-1:0] shifted;
    logic [TOTAL_WIDTH-1:0] shifted_complement;

    generate
        if (SHIFT_DIR) begin // shift 
            assign shifted = input_bits << shift_amt;
            assign shifted_complement = input_bits >> (TOTAL_WIDTH - shift_amt);
        end else  begin
            assign shifted = input_bits >> shift_amt;
            assign shifted_complement = input_bits << (TOTAL_WIDTH - shift_amt);
        end
    endgenerate

    assign output_bits = shifted + shifted_complement;
endmodule

`endif