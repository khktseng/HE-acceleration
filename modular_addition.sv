module modular_addition(a, b, m, c);
    parameter DATA_WIDTH = 8;

    input [DATA_WIDTH-1:0] a;
    input [DATA_WIDTH-1:0] b;
    input [DATA_WIDTH-1:0] m;
    output [DATA_WIDTH-1:0] c;

    wire [DATA_WIDTH-1:0] sum;

    assign sum = a + b;
    assign c =

    always @(*) begin
        c = a + b;
        if (c > m)
            c = c - m;
    end
endmodule
