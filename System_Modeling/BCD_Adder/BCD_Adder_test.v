`timescale 1ns / 1ps

module BCD_Adder_test();

    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire [3:0] Sum;
    wire Cout;

    BCD_Adder DUT(
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
        A = 9; B = 8; Cin = 0;
        #10 B = 9;
        #10 A = 7; B = 2;
        #20 B = 4;
        #10 A = 5; B = 2;
        #10 $finish;
    end

    initial
        $monitor($time," Cout = %d, Sum %d =%d +%d + %d", Cout, Sum, A, B, Cin);

endmodule
