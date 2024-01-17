`ifndef CIRCULAR_SHIFT_SV
`define CIRCULAR_SHIFT_SV

// shifts right by shift_amt
module CIRCULAR_SHIFT_SV
#(
    parameter DATA_WIDTH = 64,
    parameter NUM_PE = 8,

    localparam SHIFT_AMT_BITS = $clog2(NUM_PE)
)
(
    input logic [DATA_WIDTH-1:0] input_row [0:NUM_PE-1],
    input logic [SHIFT_AMT_BITS-1:0] shift_amt,
    output logic [DATA_WIDTH-1:0] output_row [0:NUM_PE-1]
);
    integer i;
    always_comb begin
        for (i = 0; i < NUM_PE; i = i + 1) begin
            if (i + shift_amt >= NUM_PE)
                output_row [i + shift_amt - NUM_PE] = input_row[i];
            else
                output_row[i + shift_amt] = input_row[i];
        end
    end

endmodule

`endif