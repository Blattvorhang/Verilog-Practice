`timescale 1ns / 1ps

module Cascaded_32bit_Adder(
        input [31:0] A,
        input [31:0] B,
        input Cin,
        output [31:0] Sum,
        output Cout
    );

    // Construct a cascaded 32-bit adder using 4-bit carry-lookahead adders
    // eight 4-bit adders
    wire [6:0] C;

    CLA_4bit CLA_4bit_0(A[3:0],   B[3:0],   Cin,  Sum[3:0],   C[0]);
    CLA_4bit CLA_4bit_1(A[7:4],   B[7:4],   C[0], Sum[7:4],   C[1]);
    CLA_4bit CLA_4bit_2(A[11:8],  B[11:8],  C[1], Sum[11:8],  C[2]);
    CLA_4bit CLA_4bit_3(A[15:12], B[15:12], C[2], Sum[15:12], C[3]);
    CLA_4bit CLA_4bit_4(A[19:16], B[19:16], C[3], Sum[19:16], C[4]);
    CLA_4bit CLA_4bit_5(A[23:20], B[23:20], C[4], Sum[23:20], C[5]);
    CLA_4bit CLA_4bit_6(A[27:24], B[27:24], C[5], Sum[27:24], C[6]);
    CLA_4bit CLA_4bit_7(A[31:28], B[31:28], C[6], Sum[31:28], Cout);

endmodule

module CLA_4bit(
        input [3:0] A,
        input [3:0] B,
        input Cin,
        output [3:0] Sum,
        output Cout
    );

    wire [3:0] P;
    wire [3:0] G;
    wire [3:0] C;

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign Sum = P ^ C;
    
endmodule