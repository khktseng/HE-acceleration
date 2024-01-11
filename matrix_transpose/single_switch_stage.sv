module single_switch_stage(clk, rst, ctrl, in_elements_down, in_elements_across, out_elements);
    parameter DATA_WIDTH = 64;
    parameter NUM_MG = 8;
    parameter NUM_PE = NUM_MG;
    
    parameter SI = 0;
    parameter SJ = 0;

    localparam CHUNK_WIDTH = NUM_MG / NUM_PE * DATA_WIDTH;

    input clk, rst, ctrl;
    input logic [CHUNK_WIDTH-1:0] in_elements_down [0:NUM_PE-1];
    input logic [CHUNK_WIDTH-1:0] in_elements_across [0:NUM_PE-1];
    output logic [CHUNK_WIDTH-1:0] out_elements [0:NUM_PE-1];

    localparam keep_start_idx = SJ;
    localparam keep_end_idx = (SJ + SI) % NUM_PE;

    localparam across_left_end_idx = SJ;
    localparam across_right_start_idx = (SJ + SI + 2) % NUM_PE;

    localparam shift_start_idx = (keep_end_idx + 1) % NUM_PE;
    localparam shift_end_idx = (keep_start_idx == 0) ? NUM_PE - 1 : keep_start_idx - 1;

    localparam SHIFT_ELEMENTS = NUM_PE - SI - 1;

    logic [CHUNK_WIDTH-1:0] next_output [0:NUM_PE-1];
    logic [CHUNK_WIDTH-1:0] shift_elements_i [0:SHIFT_ELEMENTS-1];
    logic [CHUNK_WIDTH-1:0] shift_elements [0:SHIFT_ELEMENTS-1];
    logic [CHUNK_WIDTH-1:0] temp;

    genvar i;
    // Keep items
    generate
        if (keep_start_idx == keep_end_idx) begin
            assign next_output[keep_start_idx] = in_elements_down[keep_start_idx];
        end else if (keep_end_idx < keep_start_idx) begin
            for (i = keep_start_idx; i < NUM_PE; i = i + 1) begin
                assign next_output[i] = in_elements_down[i];
            end
            for (i = 0; i <= keep_end_idx; i = i + 1) begin
                assign next_output[i] = in_elements_down[i];
            end
            //assign next_output[keep_start_idx:NUM_PE-1] = in_elements_down[keep_start_idx:NUM_PE-1];
            //assign next_output[0:keep_end_idx] = in_elements_down[0:keep_end_idx];
        end else begin
            for (i = keep_start_idx; i <= keep_end_idx; i = i + 1) begin
                assign next_output[i] = in_elements_down[i];
            end
            //assign next_output[keep_start_idx:keep_end_idx] = in_elements_down[keep_start_idx:keep_end_idx];
        end

    // Keep across items
        if (across_right_start_idx <= across_left_end_idx) begin
            for (i = 0; i < SHIFT_ELEMENTS; i = i + 1) begin
                assign shift_elements_i[i] = in_elements_across[across_right_start_idx + i];
            end
        end else begin
            for (i = 0; i <= across_left_end_idx; i = i + 1) begin
                assign shift_elements_i[i] = in_elements_across[i];
            end
            for (i = across_right_start_idx; i < NUM_PE; i = i + 1) begin
                assign shift_elements_i[i-SI-1] = in_elements_across[i];
            end
        end

    // Shifted items are reversed from PE_0 to PE_last
        if (SJ == NUM_PE - 1) begin
            for (i = 0; i < SHIFT_ELEMENTS; i = i + 1) begin
                assign shift_elements[i] = shift_elements_i[SHIFT_ELEMENTS-1-i];
            end
        end else begin
            for (i = 0; i < SHIFT_ELEMENTS; i = i + 1) begin
                assign shift_elements[i] = shift_elements_i[i];
            end
        end

    // Place shifted items
        if (shift_start_idx <= shift_end_idx) begin
            for (i = 0; i < SHIFT_ELEMENTS; i = i + 1) begin
                assign next_output[shift_start_idx + i] = shift_elements[i];
            end
        end else begin
            for (i = 0; i <= shift_end_idx; i = i + 1) begin
                assign next_output[i] = shift_elements[i];
            end
            for (i = shift_start_idx; i < NUM_PE; i = i + 1) begin
                assign next_output[i] = shift_elements[i-SI-1];
            end
        end
    endgenerate

    integer j;
    always_ff @(posedge clk) begin
        if (rst) begin
            for (j = 0; j < NUM_PE; j = j + 1) begin
                out_elements[j] <= 0;
            end
        end else begin
            if (ctrl) begin // Transpose
                for (j = 0; j < NUM_PE; j = j + 1) begin
                    out_elements[j] <= next_output[j];
                end
            end else begin
                for (j = 0; j < NUM_PE; j = j + 1) begin
                    out_elements[j] <= in_elements_down[j];
                end
            end
        end
    end

endmodule
