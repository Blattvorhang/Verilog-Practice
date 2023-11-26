`timescale 1ns / 1ps

module ALU_74381(
        input [3:0] A,
        input [3:0] B,
        input [2:0] s,
        output reg [3:0] F
    );

    // Define parameters
    parameter Clear  = 3'b000;
    parameter B_A    = 3'b001;
    parameter A_B    = 3'b010;
    parameter ADD    = 3'b011;
    parameter XOR    = 3'b100;
    parameter OR     = 3'b101;
    parameter AND    = 3'b110;
    parameter Preset = 3'b111;

    always @(*) begin
        case (s)
            Clear:   F = 4'b0000;
            B_A:     F = B - A;
            A_B:     F = A - B;
            ADD:     F = A + B;
            XOR:     F = A ^ B;
            OR:      F = A | B;
            AND:     F = A & B;
            Preset:  F = 4'b1111;
            default: F = 4'b0000;
        endcase
    end

endmodule
