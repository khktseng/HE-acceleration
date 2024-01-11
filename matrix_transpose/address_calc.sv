`ifndef ADDRESS_CALC_SV
`define ADDRESS_CALC_SV

module address_calc
#(
    parameter DATA_WIDTH = 64,
    parameter ARR_SIZE = 8,         // larger array width /height in number of data elements
    parameter ADDR_WIDTH = 64,
    parameter CHUNK_SIZE = 4        // chunk width / height in number of data elements
)(
    input logic clk,
    input logic rst,
    input logic ctrl,           // 1 = transpose
    input logic [ADDR_WIDTH-1:0] base_addr,
    input logic [ADDR_WIDTH-1:0] chunk_addr,
    output logic [ADDR_WIDTH-1:0] store_addr
);
    localparam BYTE = 8;
    localparam ROW_INC = DATA_WIDTH * ARR_SIZE / BYTE;
    localparam COL_INC = DATA_WIDTH / BYTE;
    localparam CHUNK_IDX_WIDTH = $clog2(ARR_SIZE / CHUNK_SIZE);
    localparam CHUNK_BYTES = DATA_WIDTH / BYTE * CHUNK_SIZE;
    localparam CHUNK_I_MOD_1 = $clog2(ARR_SIZE);

    localparam CHUNK_BYTES_L = $clog2(CHUNK_BYTES);
    localparam ARR_SIZE_L = $clog2(ARR_SIZE);

    //localparam CHUNK_ROW_INC = 

    logic [CHUNK_IDX_WIDTH-1:0] chunk_i;
    logic [CHUNK_IDX_WIDTH-1:0] chunk_j;
    logic [CHUNK_IDX_WIDTH-1:0] chunk_i_mask;
    logic [ADDR_WIDTH-1:0] diff_addr;
    logic [ADDR_WIDTH-1:0] n_store_addr;

    // suggested to choose DATA_WIDTH, CHUNK_SIZE so that division can just be a shift
    assign diff_addr = chunk_addr - base_addr;
    assign chunk_i_mask = 0 + {CHUNK_I_MOD_1{1'b1}};
    assign chunk_i = (diff_addr >> CHUNK_BYTES_L) & chunk_i_mask;
    assign chunk_j = (diff_addr >> CHUNK_BYTES_L) >> ARR_SIZE_L;
    assign n_store_addr = (chunk_i << CHUNK_BYTES_L << ARR_SIZE_L) + (chunk_j << CHUNK_BYTES_L) + base_addr;

    always @(posedge clk) begin
        if (rst) begin
            store_addr <= 0;
        end else begin
            if (ctrl)
                store_addr <= n_store_addr;
            else
                store_addr <= chunk_addr;
        end
    end

endmodule

`endif