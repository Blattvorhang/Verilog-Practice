`timescale 1ns / 1ps

module BCD_Adder(
        input [3:0] A,
        input [3:0] B,
        input Cin,
        output [3:0] Sum,
        output Cout
    );

    wire [4:0] Sum_temp;

    assign Sum_temp = A + B + Cin;
    assign {Cout, Sum} = Sum_temp > 9 ? Sum_temp + 6 : Sum_temp;

endmodule
