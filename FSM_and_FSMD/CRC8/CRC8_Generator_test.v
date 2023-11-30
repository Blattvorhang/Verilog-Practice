`timescale 1ns / 1ps

module CRC8_Generator_test;

    reg clk;
    reg reset;
    reg data;
    reg enable;
    wire [7:0] crc;

    CRC8_Generator DUT(
        .clk(clk),
        .reset(reset),
        .data(data),
        .enable(enable),
        .crc(crc)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1;
        data = 0;
        enable = 0;
        #10 reset = 0;
        enable = 1;
        // 16 bits data: 0b1110_1100_1011_0101 (0xECB5)
        // MSB first
        #10 data = 1;
        #10 data = 1;
        #10 data = 1;
        #10 data = 0;

        #10 data = 1;
        #10 data = 1;
        #10 data = 0;
        #10 data = 0;

        #10 data = 1;
        #10 data = 0;
        #10 data = 1;
        #10 data = 1;

        #10 data = 0;
        #10 data = 1;
        #10 data = 0;
        #10 data = 1;

        // LSB first
        // #10 data = 1;
        // #10 data = 0;
        // #10 data = 1;
        // #10 data = 0;

        // #10 data = 1;
        // #10 data = 1;
        // #10 data = 0;
        // #10 data = 1;

        // #10 data = 0;
        // #10 data = 0;
        // #10 data = 1;
        // #10 data = 1;

        // #10 data = 0;
        // #10 data = 1;
        // #10 data = 1;
        // #10 data = 1;
        #30 $finish;
    end

endmodule
