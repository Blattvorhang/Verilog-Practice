`timescale 1ns / 1ps

module TrafficLamps_test;

    reg clk, rst;
    wire [1:0] displayer1, displayer2;
    wire [3:0] left_time;

    TrafficLamps DUT(
        .clk(clk),
        .rst(rst),
        .displayer1(displayer1),
        .displayer2(displayer2),
        .left_time(left_time)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #10 rst = 0;
        #1000 $finish;
    end

endmodule
