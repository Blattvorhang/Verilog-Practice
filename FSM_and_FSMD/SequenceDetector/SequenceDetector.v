`timescale 1ns / 1ps

module SequenceDetector(
        input clk,
        input rst,
        input x,
        input y,
        output reg [1:0] z
    );

    // if (x, y) = 00 01 11 10 00 01 11 then z = 10
    // if (x, y) = 00 10 11 01 00 10 11 then z = 11
    // otherwise z = 00

    localparam S0                     = 4'b0000;
    localparam S_00                   = 4'b0001;
    localparam S_00_01                = 4'b0010;
    localparam S_00_01_11             = 4'b0011;
    localparam S_00_01_11_10          = 4'b0100;
    localparam S_00_01_11_10_00       = 4'b0101;
    localparam S_00_01_11_10_00_01    = 4'b0110;
    localparam S_00_01_11_10_00_01_11 = 4'b0111;
    localparam S_00_10                = 4'b1000;
    localparam S_00_10_11             = 4'b1001;
    localparam S_00_10_11_01          = 4'b1010;
    localparam S_00_10_11_01_00       = 4'b1011;
    localparam S_00_10_11_01_00_10    = 4'b1100;
    localparam S_00_10_11_01_00_10_11 = 4'b1101;

    reg [3:0] state, next_state;

    initial begin
        state = S0;
        z = 2'b00;
    end

    // state register block
    always @(posedge clk) begin
        if(rst) begin
            state <= S0;
            z <= 2'b00;
        end else begin
            state <= next_state;
        end
    end

    // next state logic
    always @(*) begin
        next_state = S0;
        case(state)
            S0: begin
                if (x == 0 && y == 0)
                    next_state = S_00;
            end
            S_00: begin
                if (x == 0 && y == 1)
                    next_state = S_00_01;
                else if (x == 1 && y == 0)
                    next_state = S_00_10;
                else if (x == 0 && y == 0)
                    next_state = S_00;
            end
            S_00_01: begin
                if (x == 1 && y == 1)
                    next_state = S_00_01_11;
                else if (x == 0 && y == 0)
                    next_state = S_00;
            end
            S_00_10: begin
                if (x == 1 && y == 1)
                    next_state = S_00_10_11;
                else if (x == 0 && y == 0)
                    next_state = S_00;
            end
            S_00_01_11: begin
                if (x == 1 && y == 0)
                    next_state = S_00_01_11_10;
                else if (x == 0 && y == 0)
                    next_state = S_00;
            end
            S_00_10_11: begin
                if (x == 0 && y == 1)
                    next_state = S_00_10_11_01;
                else if (x == 0 && y == 0)
                    next_state = S_00;
            end
            S_00_01_11_10: begin
                if (x == 0 && y == 0)
                    next_state = S_00_01_11_10_00;
            end
            S_00_10_11_01: begin
                if (x == 0 && y == 0)
                    next_state = S_00_10_11_01_00;
            end
            S_00_01_11_10_00: begin
                if (x == 0 && y == 1)
                    next_state = S_00_01_11_10_00_01;
                else if (x == 1 && y == 0)
                    next_state = S_00_10;
                else if (x == 0 && y == 0)
                    next_state = S_00;
            end
            S_00_10_11_01_00: begin
                if (x == 1 && y == 0)
                    next_state = S_00_10_11_01_00_10;
                else if (x == 0 && y == 1)
                    next_state = S_00_01;
                else if (x == 0 && y == 0)
                    next_state = S_00;
            end
            S_00_01_11_10_00_01: begin
                if (x == 1 && y == 1)
                    next_state = S_00_01_11_10_00_01_11;
                else if (x == 0 && y == 0)
                    next_state = S_00;
            end
            S_00_10_11_01_00_10: begin
                if (x == 1 && y == 1)
                    next_state = S_00_10_11_01_00_10_11;
                else if (x == 0 && y == 0)
                    next_state = S_00;
            end
            S_00_01_11_10_00_01_11: begin
                if (x == 1 && y == 0)
                    next_state = S_00_01_11_10;
                else if (x == 0 && y == 0)
                    next_state = S_00;
            end
            S_00_10_11_01_00_10_11: begin
                if (x == 0 && y == 1)
                    next_state = S_00_10_11_01;
                else if (x == 0 && y == 0)
                    next_state = S_00;
            end
        endcase
    end

    // output logic
    always @(*) begin
        case(state)
            S_00_01_11_10_00_01_11: z = 2'b10;
            S_00_10_11_01_00_10_11: z = 2'b11;
            default: z = 2'b00;
        endcase
    end

endmodule
