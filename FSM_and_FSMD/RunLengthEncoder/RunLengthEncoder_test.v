`timescale 1ns / 1ps

module RunLengthEncoder_test;

    reg [7:0] in;
    reg clk;
    wire [15:0] out;
    wire valid;

    RunLengthEncoder DUT(
        .in(in),
        .clk(clk),
        .out(out),
        .valid(valid)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        in = 0;
        // "aaaabbccca"
        #10 in = 8'h61;
        #10 in = 8'h61;
        #10 in = 8'h61;
        #10 in = 8'h61;
        #10 in = 8'h62;
        #10 in = 8'h62;
        #10 in = 8'h63;
        #10 in = 8'h63;
        #10 in = 8'h63;
        #10 in = 8'h61;
        #10 in = 8'h00;
        #30 $finish;
    end

endmodule
