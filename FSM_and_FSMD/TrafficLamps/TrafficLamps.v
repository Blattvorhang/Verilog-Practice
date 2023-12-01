`timescale 1ns / 1ps

module TrafficLamps(
        input clk,
        input rst,
        output reg [1:0] displayer1,
        output reg [1:0] displayer2,
        output reg [3:0] left_time  // < 10s, assume 1s = 1 clk
    );

    // 1: main street
    // 2: branch street
    // R -> Y -> G -> Y -> R
    // R1 = 30s, Y1 = 3s, G1 = 40s
    // R2 = 40s, Y2 = 3s, G2 = 30s
    // so one timer is enough

    localparam R1 = 3'b000;
    localparam Y1_to_G1 = 3'b001;
    localparam Y1_to_R1 = 3'b010;
    localparam G1 = 3'b011;
    localparam R2 = 3'b100;
    localparam Y2_to_G2 = 3'b101;
    localparam Y2_to_R2 = 3'b110;
    localparam G2 = 3'b111;

    localparam R = 2'b00;
    localparam Y = 2'b01;
    localparam G = 2'b10;

    reg [2:0] state1, next_state1;
    reg [2:0] state2, next_state2;
    reg [5:0] timer;

    initial begin
        state1 = G1;
        state2 = R2;
        displayer1 = G;
        displayer2 = R;
        left_time = 4'b1111;  // invalid
        timer = 40;
    end

    // state register block
    always @(posedge clk) begin
        if(rst) begin
            state1 <= G1;
            state2 <= R2;
            displayer1 <= G;
            displayer2 <= R;
            left_time <= 4'b1111;  // invalid
            timer <= 40;
        end else begin
            state1 <= next_state1;
            state2 <= next_state2;
            timer <= timer - 1;
        end
    end

    // next state logic
    always @(*) begin
        next_state1 = state1;
        next_state2 = state2;
        case(state1)
            G1: begin
                if (timer == 0) begin
                    next_state1 = Y1_to_R1;
                    next_state2 = Y2_to_G2;
                    timer = 3;
                end
            end
            Y1_to_R1: begin
                if (timer == 0) begin
                    next_state1 = R1;
                    next_state2 = G2;
                    timer = 30;
                end
            end
            R1: begin
                if (timer == 0) begin
                    next_state1 = Y1_to_G1;
                    next_state2 = Y2_to_R2;
                    timer = 3;
                end
            end
            Y1_to_G1: begin
                if (timer == 0) begin
                    next_state1 = G1;
                    next_state2 = R2;
                    timer = 40;
                end
            end
        endcase
    end

    // output logic
    always @(*) begin
        if (timer < 10) begin
            left_time = timer;
        end else begin
            left_time = 4'b1111;  // invalid
        end
        case(state1)
            G1: begin
                displayer1 = G;
            end
            Y1_to_R1: begin
                displayer1 = Y;
            end
            R1: begin
                displayer1 = R;
            end
            Y1_to_G1: begin
                displayer1 = Y;
            end
        endcase
        case(state2)
            G2: begin
                displayer2 = G;
            end
            Y2_to_R2: begin
                displayer2 = Y;
            end
            R2: begin
                displayer2 = R;
            end
            Y2_to_G2: begin
                displayer2 = Y;
            end
        endcase
    end

endmodule
