`timescale 1ns/10ps
`define DATA_WIDTH 8
`include "./modular_addition.sv"

module tb_modular_addition;
    logic clk;
    logic [7:0] a, b, m, c;

    modular_addition DUT(clk, a, b, m, c);

    always #5 clk <= ~clk;

    initial begin
        $dumpfile("ma.vcd");
        $dumpvars(0, tb_modular_addition);
        $monitor("clk=%b, a=%d, b=%d, m=%d, c=%d", clk, a, b, m ,c);
        clk <= 0;
        m = 9;
        a = 8; b = 7; #10;
        $finish;

    end
endmodule
    
