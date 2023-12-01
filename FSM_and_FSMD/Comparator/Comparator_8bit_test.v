`timescale 1ns / 1ps

module Comparator_8bit_test;

    reg clk, rst, start, ai, bi;
    wire [1:0] sout;

    Comparator_8bit DUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .ai(ai),
        .bi(bi),
        .sout(sout)
    );

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        ai = 0;
        bi = 0;
    end

    always #5 clk = ~clk;

    initial begin
        #10 rst = 0;
        #10 start = 1;
        #10 start = 0; ai = 1; bi = 0;
        #10 ai = 1; bi = 1;
        #10 ai = 0; bi = 1;
        #10 ai = 0; bi = 1;
        #10 ai = 1; bi = 0;
        #10 ai = 1; bi = 1;
        #10 ai = 0; bi = 1;
        #10 ai = 1; bi = 0;
        #10 ai = 0; bi = 0;
        #20 $finish;
    end

endmodule
