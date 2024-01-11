`include "address_calc.sv"

module tb_address_calc();
    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 8;
    localparam ARR_SIZE = 8;
    localparam CHUNK_SIZE = 2;

    logic clk, rst, ctrl;
    logic [ADDR_WIDTH-1:0] base_addr, chunk_addr, store_addr;

    address_calc #(
        DATA_WIDTH,
        ARR_SIZE,
        ADDR_WIDTH,
        CHUNK_SIZE
    ) DUT (
        .clk(clk),
        .rst(rst),
        .ctrl(ctrl),
        .base_addr(base_addr),
        .chunk_addr(chunk_addr),
        .store_addr(store_addr)
    );

    always #5 clk <= ~clk;
    initial clk = 1;

    task automatic do_test(
            input logic [ADDR_WIDTH-1:0] t_chunk_addr
        );
            chunk_addr = t_chunk_addr;
            #9;
            $display("Base: %0d, Chunk: %0d, Store = %0d", base_addr, chunk_addr, store_addr);
            #1;
        endtask

    integer i;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        rst = 1;
        ctrl = 1;
        base_addr = 0;

        #15;

        rst = 0;
        
        do_test(0);
        do_test(8);
        do_test(16);
        do_test(24);
        do_test(64);
        do_test(72);
        do_test(80);
        do_test(88);
        do_test(128);
        do_test(136);
        do_test(144);
        do_test(152);
        do_test(192);
        do_test(200);
        do_test(208);
        do_test(216);
        
        $finish;
    end
endmodule