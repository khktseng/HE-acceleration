`timescale 1ns/10ps
`define DATA_WIDTH 8

module tb_modular_addition;
    logic clk;
    logic [DATA_WIDTH-1:0] a, b, m, c;

    modular_addition(clk, a, b, m, c);

    initial begin

    end
endmodule
    
