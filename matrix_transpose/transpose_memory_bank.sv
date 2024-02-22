`ifndef TRANSPOSE_MEMORY_BANK_SV
`define TRANSPOSE_MEMORY_BANK_SV

module transpose_memory_bank
#(
    parameter DATA_WIDTH = 64,
    parameter NUM_PE = 8,

    parameter ADDR_WIDTH = $clog2(NUM_PE) + 1,
    localparam MEMORY_SIZE = NUM_PE * DATA_WIDTH * 2
)(
    input logic clk,
    input logic rst,

    input logic wen,
    input logic [ADDR_WIDTH-1:0] write_addr [0:NUM_PE-1],
    input logic [DATA_WIDTH-1:0] write_data [0:NUM_PE-1],

    input logic ren,
    input logic [ADDR_WIDTH-1:0] read_addr [0:NUM_PE-1],
    output logic [DATA_WIDTH-1:0] read_data [0:NUM_PE-1]
);

    genvar i;
    generate
        for (i = 0; i < NUM_PE; i = i + 1) begin
            xpm_memory_sdpram #(
                .ADDR_WIDTH_A(ADDR_WIDTH),
                .ADDR_WIDTH_B(ADDR_WIDTH),
                .BYTE_WRITE_WIDTH_A(DATA_WIDTH),
                .CLOCKING_MODE("common_clock"),
                .ECC_MODE("no_ecc"),
                .MEMORY_PRIMITIVE("block"),
                .MEMORY_SIZE(MEMORY_SIZE),
                .READ_DATA_WIDTH_B(DATA_WIDTH),
                .READ_LATENCY_B(1),
                .WRITE_DATA_WIDTH_A(DATA_WIDTH),
                .WRITE_MODE_B("read_first"),
                .WRITE_PROTECT(0) // Default is 1, use 0 only if always ena == wea
            )sdpram_inst(
                .rstb(rst),
                .clka(clk),

                .ena(wen),
                .wea(wen),
                .addra(write_addr[i]),
                .dina(write_data[i]),

                .enb(ren),
                .addrb(read_addr[i]),
                .doutb(read_data[i]),
                .regceb(1'b1)
            );
        end
    endgenerate

endmodule

`endif