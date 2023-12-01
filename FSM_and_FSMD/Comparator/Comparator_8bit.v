`timescale 1ns / 1ps

module Comparator_8bit(
        input clk,
        input rst,
        input start,
        input ai,
        input bi,
        output reg [1:0] sout //00(x), 01(<), 10(=), 11(>)
    );

    // Compare two 8-bit numbers as serial input using FSM
    // ai and bi are inputted serially, LSB first
    localparam invalid = 2'b00;
    localparam less = 2'b01;
    localparam equal = 2'b10;
    localparam greater = 2'b11;

    localparam IDLE = 2'b00;
    localparam COMPARE = 2'b01;
    localparam DONE = 2'b10;

    reg [7:0] a, b;
    reg [1:0] state, next_state;
    reg [2:0] counter;

    // State register block
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            state <= IDLE;
            a <= 'b0;
            b <= 'b0;
            counter <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        $display("counter = %d, state = %d", counter, state);
        case (state)
            IDLE: begin
                if (start) begin
                    counter = 0;
                    next_state = COMPARE;
                end
            end
            COMPARE: begin
                if (counter == 7) begin
                    next_state = DONE;
                end
                a[counter] = ai;
                b[counter] = bi;
                counter = counter + 1;
            end
            DONE: begin
                counter = 0;
                next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            IDLE: begin
                sout = invalid;
            end
            COMPARE: begin
                sout = invalid;
            end
            DONE: begin
                if (a > b) begin
                    sout = greater;
                end else if (a < b) begin
                    sout = less;
                end else begin
                    sout = equal;
                end
            end
        endcase
    end

endmodule
