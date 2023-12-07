module modular_addition(clk, reset, a, b, m, c);
    parameter DATA_WIDTH = 8;

    input clk, reset;
    input [DATA_WIDTH-1:0] a;
    input [DATA_WIDTH-1:0] b;
    input [DATA_WIDTH-1:0] m;
    output logic [DATA_WIDTH-1:0] c;

    logic [DATA_WIDTH:0] out;

    always_comb begin
        out = a + b;
        if (out > m) begin
            out = out - m;
        end
    end

    always_ff @(posedge clk) begin
        c <= out;

        if (reset) begin
            c <= 'bx;
        end
    end
endmodule
