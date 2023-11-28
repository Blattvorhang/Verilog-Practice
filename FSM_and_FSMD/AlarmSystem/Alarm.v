`timescale 1ns / 1ps

module Alarm(
        input clk,
        input infraredSensor,
        input armButton,
        input disarmButton,
        input testButton,
        output reg alarm
    );

    localparam DISARM = 2'b00;
    localparam ARM    = 2'b01;
    localparam TEST   = 2'b10;
    localparam ALARM  = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] timer;

    initial begin
        state = DISARM;
        timer = 0;
    end

    always @(posedge armButton, posedge disarmButton, posedge testButton) begin
        if (armButton) begin
            next_state = ARM;
        end else if (disarmButton) begin
            next_state = DISARM;
        end else if (testButton) begin
            next_state = TEST;
        end
    end

    always @(posedge clk) begin
        if (infraredSensor) begin
            if (timer < 5) begin
                timer <= timer + 1;
            end
        end else begin
            timer <= 0;
        end
    end

    always @(posedge clk, posedge armButton, posedge disarmButton, posedge testButton) begin
        state <= next_state;
        case (state)
            DISARM: begin
                alarm <= 0;
            end
            ARM: begin
                if (timer >= 5) begin
                    next_state = ALARM;
                end
            end
            TEST: begin
                alarm <= 1;
            end
            ALARM: begin
                alarm <= 1;
            end
        endcase
    end

endmodule