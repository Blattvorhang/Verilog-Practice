`timescale 1ns / 1ps

module HammingEncoder(
        input clk,
        input reset,
        input start,
        input [3:0] data,
        output reg [6:0] code
    );

    localparam IDLE = 1'b0;
    localparam ENCODE = 1'b1;

    reg state, next_state;
    reg [2:0] parity_bits;

    // state register block
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
            code <= 8'b0;
            parity_bits <= 3'b0;
        end else begin
            state <= next_state;
        end
    end

    // next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = ENCODE;
                end
            end
            ENCODE: begin
                next_state = IDLE;
            end
        endcase
    end

    // output logic
    always @(*) begin
        case (state)
            IDLE: begin
                code = 8'b0;
            end
            ENCODE: begin
                parity_bits[0] = data[0] ^ data[1] ^ data[3];
                parity_bits[1] = data[0] ^ data[2] ^ data[3];
                parity_bits[2] = data[1] ^ data[2] ^ data[3];
                code[0] = parity_bits[0];
                code[1] = parity_bits[1];
                code[2] = data[0];
                code[3] = parity_bits[2];
                code[4] = data[1];
                code[5] = data[2];
                code[6] = data[3];
            end
        endcase
    end

endmodule
