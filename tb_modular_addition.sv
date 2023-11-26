`timescale 1ns/10ps
`define DATA_WIDTH 8

module tb_modular_addition;
    logic clk;
    logic [DATA_WIDTH-1:0] a, b, m, c;

    modular_addition DUT(clk, a, b, m, c);

    always #5 clk <= ~clk;

    initial begin
        $monitor("clk=%b, a=%d, b=%d, m=%d, c=%d", clk, a, b, m ,c);
        clk <= 0;
        m = 9;
        a = 8; b = 7; #10;
        $finish;

    end
endmodule
    
