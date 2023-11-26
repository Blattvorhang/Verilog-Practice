`timescale 1ns / 1ps

module Cascaded_32bit_Adder_test();

    reg [31:0] A;
    reg [31:0] B;
    reg Cin;
    wire [31:0] Sum;
    wire Cout;

    Cascaded_32bit_Adder DUT(
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
        A = 32'd12; B = 32'd34; Cin = 0;
        #10 B = 32'd56;
        #10 A = 32'd78; B = 32'd90;
        #20 B = 32'd12; Cin = 1;
        #10 A = 32'd34; B = 32'd56;
        #10 $finish;
    end

    initial
        $monitor($time," Cout = %d, Sum %d =%d +%d + %d", Cout, Sum, A, B, Cin);

endmodule
