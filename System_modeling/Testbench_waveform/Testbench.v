`timescale 1ns / 1ps

module Testbench;

    reg clk;
    reg [7:0] A;
    reg [7:0] B;

    initial begin
        clk = 0;
        #150 A = 20; B = 40;
        #200 B = 240;
        #200 A = 255; B = 10;
        #300 $finish;
    end

    always #50 clk = ~clk;

endmodule
