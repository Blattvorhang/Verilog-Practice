`timescale 1ns / 1ps

module Factorial(
        input clk,
        input rst,
        input start,
        input [3:0] n,  // <= 12
        output reg [31:0] fac,
        output reg done
    );

    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] i, next_i;
    reg [3:0] n_reg;
    reg [31:0] fac_tmp, next_fac_tmp;
    reg cnt_en, cal_en;

    initial begin
        state = IDLE;
        i = 1;
        n_reg = 0;
        fac_tmp = 1;
        done = 0;
    end

    // control path state register block
    always @(posedge clk) begin
        if (rst) state <= IDLE;
        else state <= next_state;
    end

    // control path next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = CALC;
                    n_reg = n;
                end
            end
            CALC: begin
                if (i == n_reg)
                    next_state = DONE;
            end
            DONE: begin
                next_state = IDLE;
                n_reg = 0;
            end
        endcase
    end

    // control path output logic
    always @(*) begin
        cnt_en = 0;
        cal_en = 0;
        case (state)
            IDLE: begin
                cnt_en = 0;
                cal_en = 0;
                done = 0;
            end
            CALC: begin
                cnt_en = 1;
                cal_en = 1;
                done = 0;
            end
            DONE: begin
                cnt_en = 0;
                cal_en = 0;
                done = 1;
            end
        endcase
    end

    // counter data path current register block
    always @(posedge clk) begin
        if (rst) i <= 1;
        else i <= next_i;
    end

    // counter data path next register logic
    always @(*) begin
        if (cnt_en) next_i = i + 1;
        else next_i = 1;
    end

    // calculation data path current register block
    always @(posedge clk) begin
        if (rst) fac_tmp <= 1;
        else fac_tmp <= next_fac_tmp;
    end

    // calculation data path next register logic
    always @(*) begin
        if (cal_en) next_fac_tmp = fac_tmp * i;
        else next_fac_tmp = 1;
    end

    // data output
    always @(*) begin
        if (state == DONE)
            fac = fac_tmp;
        else
            fac = 0;
    end

endmodule
