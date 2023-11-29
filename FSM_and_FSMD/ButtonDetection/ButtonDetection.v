`timescale 1ns / 1ps

module ButtonDetection(
        input clk,
        input BTNC,
        output reg press_flag,
        output reg release_flag
    );

    // Button Detection and Debouncing
    // BTNC: 0 is pressed, 1 is released
    // 10ms debounce time
    
    // TEMP state is used to avoid bouncing
    localparam PRESS_TEMP   = 2'b00;
    localparam RELEASE_TEMP = 2'b01;
    localparam PRESS        = 2'b10;
    localparam RELEASE      = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] counter;  // Assume 1 cycle is 1ms

    initial begin
        state = RELEASE;
        counter = 0;
    end

    // state transition
    always @(posedge clk) begin
        state <= next_state;
    end

    // counter (only count when in TEMP state)
    always @(posedge clk) begin
        if (state == PRESS_TEMP || state == RELEASE_TEMP) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end
    end

    // next state logic
    always @(*) begin
        next_state = state;
        case (state)
            PRESS_TEMP: begin
                if (counter == 9) begin
                    if (BTNC == 1'b0)
                        next_state = PRESS;
                    else
                        next_state = RELEASE;
                end
            end
            RELEASE_TEMP: begin
                if (counter == 9) begin
                    if (BTNC == 1'b1)
                        next_state = RELEASE;
                    else
                        next_state = PRESS;
                end
            end
            PRESS: begin
                if (BTNC == 1'b1)
                    next_state = RELEASE_TEMP;
            end
            RELEASE: begin
                if (BTNC == 1'b0)
                    next_state = PRESS_TEMP;
            end
        endcase
    end

    // output logic
    always @(*) begin
        case (state)
            PRESS: begin
                press_flag = 1'b1;
                release_flag = 1'b0;
            end
            RELEASE: begin
                press_flag = 1'b0;
                release_flag = 1'b1;
            end
        endcase
    end

endmodule
