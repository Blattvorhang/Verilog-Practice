`timescale 1ns / 1ps

module CyclicColor(
        input clk,
        input rst,
        output reg [1:0] color //00(red), 01(green), 10(yellow)
    );

    // Cyclic color light controller
    // red(2s) -> green(3s) -> yellow(1s) -> red(2s) -> ...
    // system clock is 10MHz
    // 1s = 10,000,000 cycles
    // too slow to simulate, so we use 1ns/1ps timescale
    localparam RED = 2'b00;
    localparam GREEN = 2'b01;
    localparam YELLOW = 2'b10;

    reg [1:0] state, next_state;
    reg [2:0] counter;

    initial begin
        state = RED;
        counter = 0;
    end

    // State register block
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            state <= RED;
            counter <= 0;
        end else begin
            state <= next_state;
            counter <= counter + 1;
        end
    end

    // Next state logic
    always @(*) begin
        $display("counter = %d, state = %d", counter, state);
        next_state = state;
        case (state)
            RED: begin
                if (counter == 2) begin
                    next_state = GREEN;
                end
            end
            GREEN: begin
                if (counter == 5) begin
                    next_state = YELLOW;
                end
            end
            YELLOW: begin
                if (counter == 6) begin
                    next_state = RED;
                    counter = 0;
                end
            end
        endcase
    end

    // Output logic
    always @(*) begin
        color = state;
    end

endmodule
