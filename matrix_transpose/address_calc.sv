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
    //localparam CHUNK_ROW_INC = 

    logic [CHUNK_IDX_WIDTH-1:0] chunk_i;
    logic [CHUNK_IDX_WIDTH-1:0] chunk_j;
    logic [ADDR_WIDTH-1:0] diff_addr;
    logic [ADDR_WIDTH-1:0] n_store_addr;

    // suggested to choose DATA_WIDTH, CHUNK_SIZE so that division can just be a shift
    assign diff_addr = chunk_addr - base_addr;
    assign chunk_i = ((chunk_addr - base_addr) / CHUNK_BYTES) % ARR_SIZE;
    assign chunk_j = (chunk_addr - base_addr) / CHUNK_BYTES / ARR_SIZE;
    assign n_store_addr = chunk_i * (CHUNK_BYTES * ARR_SIZE) + chunk_j * CHUNK_BYTES;

/*
    //logic [ADDR_WIDTH-1:0] n_store_addr, n_test;
    always_comb begin
        //chunk_i = ((chunk_addr - base_addr) / (DATA_WIDTH / BYTE * CHUNK_SIZE)) % ARR_SIZE;
        //chunk_j = (chunk_addr - base_addr) / (DATA_WIDTH / BYTE * ARR_SIZE * CHUNK_SIZE);
        //n_test = chunk_i * CHUNK_BYTES * ARR_SIZE  + chunk_j * CHUNK_BYTES;
        diff_addr = chunk_addr - base_addr;
        n_store_addr = (diff_addr / CHUNK_BYTES) % ARR_SIZE) * (CHUNK_BYTES * ARR_SIZE) + (chunk_addr - );
    end*/

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