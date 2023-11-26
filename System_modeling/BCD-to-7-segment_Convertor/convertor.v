`timescale 1ns / 1ps

module Convertor(
    input w0,
    input w1,
    input w2,
    input w3,
    output reg a,
    output reg b,
    output reg c,
    output reg d,
    output reg e,
    output reg f,
    output reg g
    );

    always @(*) begin
        {a, b, c, d, e, f, g} = 7'b000_0000;  // default
        case ({w3, w2, w1, w0})
            4'b0000: {a, b, c, d, e, f, g} = 7'b111_1110;  // 0
            4'b0001: {a, b, c, d, e, f, g} = 7'b011_0000;  // 1
            4'b0010: {a, b, c, d, e, f, g} = 7'b110_1101;  // 2
            4'b0011: {a, b, c, d, e, f, g} = 7'b111_1001;  // 3
            4'b0100: {a, b, c, d, e, f, g} = 7'b011_0011;  // 4
            4'b0101: {a, b, c, d, e, f, g} = 7'b101_1011;  // 5
            4'b0110: {a, b, c, d, e, f, g} = 7'b101_1111;  // 6
            4'b0111: {a, b, c, d, e, f, g} = 7'b111_0000;  // 7
            4'b1000: {a, b, c, d, e, f, g} = 7'b111_1111;  // 8
            4'b1001: {a, b, c, d, e, f, g} = 7'b111_1011;  // 9
            default: {a, b, c, d, e, f, g} = 7'b000_0000;  // default
        endcase
    end
    
endmodule
