`ifndef MATRIX_TRANSPOSE_TOP_SV
`define MATRIX_TRANSPOSE_TOP_SV

`include "address_calc.sv"
`include "matrix_transpose_single.sv"
`include "switch_top.sv"

module matrix_transpose_top
#(
    parameter TRANSPOSE_TYPE = 0,
    parameter DATA_WIDTH = 64,
    parameter NUM_MG = 8,
    parameter NUM_PE = NUM_MG,
    parameter ARR_SIZE = 8,     // larger array width /height in number of data elements
    parameter ADDR_WIDTH = 64,
    parameter CHUNK_SIZE = 8    // chunk width / height in number of data elements
)(
    input logic clk,
    input logic rst,
    input logic ctrl,
    input logic in_val,
    input logic [DATA_WIDTH-1:0] input_elements [0:NUM_MG-1][0:NUM_PE-1],
    output logic [DATA_WIDTH-1:0] output_elements [0:NUM_MG-1][0:NUM_PE-1],
    output logic out_val,

    input logic [ADDR_WIDTH-1:0] base_addr,
    input logic [ADDR_WIDTH-1:0] chunk_addr,
    output logic [ADDR_WIDTH-1:0] store_addr
);

    logic [DATA_WIDTH-1:0] input_buffer [0:NUM_MG-1][0:NUM_PE-1];
    logic ctrl_buf;
    logic in_val_buf;
    logic base_addr_buf;
    logic chunk_addr_buf;

    always_ff @(posedge clk) begin
        if (rst) begin
            ctrl_buf <= 0;
            in_val_buf <= 0;
            base_addr_buf <= 0;
            chunk_addr_buf <= 0;
        end else begin
            ctrl_buf <= ctrl;
            in_val_buf <= in_val;
            base_addr_buf <= base_addr;
            chunk_addr_buf <= chunk_addr;
        end
    end

    genvar i, j;
    generate
        for (i = 0; i < NUM_MG; i = i + 1) begin
            for (j = 0; j < NUM_PE; j = j + 1) begin
                always_ff @(posedge clk) begin
                    input_buffer[i][j] <= input_elements[i][j];
                end
            end
        end
    endgenerate


    logic [ADDR_WIDTH-1:0] addr_gen_out;
    address_calc #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .ARR_SIZE(ARR_SIZE),
        .CHUNK_SIZE(CHUNK_SIZE)
    ) addr_gen (
        .clk        (clk),
        .rst        (rst),
        .ctrl       (ctrl_buf),
        .base_addr  (base_addr_buf),
        .chunk_addr (chunk_addr_buf),
        .store_addr (addr_gen_out)
    );

    
    generate
        case(TRANSPOSE_TYPE)
            0: begin    // switching network
                logic [ADDR_WIDTH-1:0] addr_gen_pipe [0:NUM_MG-2];
                switch_top #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .NUM_MG(NUM_MG),
                    .NUM_PE(NUM_PE)
                ) mt (
                    .clk    (clk),
                    .rst    (rst),
                    .ctrl   (ctrl_buf),
                    .input_elements (input_buffer),
                    .output_elements(output_elements),
                    .in_val (in_val_buf),
                    .out_val(out_val)
                );

                always_ff @(posedge clk) begin
                    addr_gen_pipe[0] <= addr_gen_out;
                end

                for (i = 1; i < NUM_MG -1; i = i + 1) begin
                    always @(posedge clk) begin
                        addr_gen_pipe[i] <= addr_gen_pipe[i - 1];
                    end
                end

                assign store_addr = addr_gen_pipe [NUM_MG-2];
            end
            default: begin      // Single stage CB
                matrix_transpose_single #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .NUM_MG(NUM_MG),
                    .NUM_PE(NUM_PE)
                ) mt (
                    .clk    (clk),
                    .rst    (rst),
                    .ctrl   (ctrl_buf),
                    .input_elements (input_buffer),
                    .output_elements(output_elements),
                    .in_val (in_val_buf),
                    .out_val(out_val)
                );

                assign store_addr = addr_gen_out;
            end
        endcase
    endgenerate

endmodule

`endif