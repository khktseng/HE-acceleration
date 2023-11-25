module modular_addition(a, b, m, c);
    parameter DATA_WIDTH = 8;

    input [DATA_WIDTH-1:0] a;
    input [DATA_WIDTH-1:0] b;
    input [DATA_WIDTH-1:0] m;
    output logic [DATA_WIDTH-1:0] c;

    always_comb begin
        c = a + b;
        if (c > m) begin
            c = c - m;
        end
    end
endmodule
