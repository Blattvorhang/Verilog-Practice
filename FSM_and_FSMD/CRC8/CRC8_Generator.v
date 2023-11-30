`timescale 1ns / 1ps

// 8-bit CRC Generator (CRC8)
// Serial input data: 16bits, 1 bit / cycle 
// Generator polynomial: f = x^8 + x^5 + x^4 + 1
// The LSB of each byte is shifted in first
module CRC8_Generator(
        input clk,
        input reset,
        input data,
        input enable,
        output [7:0] crc
    );

    reg [7:0] LFSR;
    wire LSB;

    assign LSB = LFSR[7] ^ data;

    always @(posedge clk, posedge reset) begin
        if (reset)
            LFSR <= 8'b0;
        else if (enable) begin
            LFSR[0] <= LSB;
            LFSR[1] <= LFSR[0];
            LFSR[2] <= LFSR[1];
            LFSR[3] <= LFSR[2];
            LFSR[4] <= LFSR[3] ^ LSB;
            LFSR[5] <= LFSR[4] ^ LSB;
            LFSR[6] <= LFSR[5];
            LFSR[7] <= LFSR[6];
        end
    end

    assign crc = LFSR;

endmodule
