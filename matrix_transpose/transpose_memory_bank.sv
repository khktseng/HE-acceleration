`ifndef TRANSPOSE_MEMORY_BANK_SV
`define TRANSPOSE_MEMORY_BANK_SV

module tranpose_memory_bank
#(
    parameter DATA_WIDTH = 64,
    parameter NUM_PE = 8,

    localparam ADDR_WIDTH = $clog2(NUM_PE)
)(
    input logic clk,
    input logic write_e,
    input logic [ADDR_WIDTH-1:0] write_addr,
    input logic [ADDR_WIDTH-1:0] read_addr,
    input logic [DATA_WIDTH-1:0] write_data,
    output logic [DATA_WIDTH-1:0] read_data
);
    reg [DATA_WIDTH-1:0] elements [0:NUM_PE-1];

    always_ff @(posedge clk) begin
        if (write_e)
            elements[write_addr] <= write_data;

        if (write_addr == read_addr)
            read_data <= write_data;
        else
            read_data <= elements[read_addr];
    end

endmodule

`endif