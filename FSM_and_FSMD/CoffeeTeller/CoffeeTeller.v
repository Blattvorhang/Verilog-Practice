`timescale 1ns / 1ps

module CoffeeTeller(
        input clk,
        input rst,
        input cancel,
        input [3:0] taste_selection,  // one-hot encoding
        input [1:0] denomination,  // 00: 0 RMB, 01: 0.5 RMB, 10: 1 RMB, 11: reserved
        output reg taste_led,
        output reg slot_open,
        output reg coin_collect,
        output reg coin_return,
        output reg change_en,
        output reg [1:0] change,  // 00: 0 RMB, 01: 0.5 RMB, 10: 1 RMB, 11: reserved
        output reg dispense_en,
        output reg [1:0] taste  // 00: taste 1, 01: taste 2, 10: taste 3, 11: taste 4
    );

    localparam IDLE = 3'b000;    // wait for coin
    localparam SALE = 3'b001;    // wait for taste selection
    localparam DONE = 3'b010;    // dispense and check change
    localparam CHANGE = 3'b011;  // dispense change
    localparam RETURN = 3'b100;  // cancel and return coin

    reg [2:0] state;

    reg [4:0] coin_counter;  // 1 is 0.1 RMB
    reg [4:0] left_coin;     // 1 is 0.1 RMB 
    reg change_finished;

    // state transition
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin  // wait for coin
                    if (cancel)
                        state <= RETURN;
                    else if (coin_counter >= 15)
                        state <= SALE;
                end
                SALE: begin  // wait for taste selection
                    if (cancel)
                        state <= RETURN;
                    else if (taste_selection != 4'b0000)
                        state <= DONE;
                end
                DONE: begin  // dispense and check change
                    if (coin_counter > 15)
                        state <= CHANGE;
                    else begin
                        state <= IDLE;
                        coin_counter <= 0;
                    end
                end
                CHANGE: begin  // dispense change
                    if (change_finished)
                        state <= IDLE;
                end
                RETURN: begin  // cancel and return coin
                    if (change_finished)
                        state <= IDLE;
                end
            endcase
        end
    end

    // coin counter
    always @(posedge clk, posedge rst) begin
        if (rst || change_finished) begin
            coin_counter <= 0;
        end else if (state == IDLE) begin
            case (denomination)
                2'b00: coin_counter <= coin_counter;
                2'b01: coin_counter <= coin_counter + 5;
                2'b10: coin_counter <= coin_counter + 10;
                2'b11: coin_counter <= coin_counter;
            endcase
        end
    end

    // taste led and slot open
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            taste_led <= 0;
            slot_open <= 1;
        end else begin
            if (state == SALE) begin  // lamps on, slot closed
                taste_led <= 1;
                slot_open <= 0;
            end else begin
                taste_led <= 0;
                slot_open <= 1;
            end
        end
    end

    // dispense enable
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            dispense_en <= 0;
        end else begin
            if (state == DONE)
                dispense_en <= 1;
            else
                dispense_en <= 0;
        end 
    end

    // taste
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            taste <= 2'b00;
        end else begin
            taste <= 2'b00;
            if (state == SALE) begin
                case (taste_selection)  // one-hot encoding
                    4'b0001: taste <= 2'b00;
                    4'b0010: taste <= 2'b01;
                    4'b0100: taste <= 2'b10;
                    4'b1000: taste <= 2'b11;
                endcase
            end
        end
    end

    // change or return
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            change_en <= 0;
            change <= 2'b00;
            change_finished <= 0;
        end else begin
            if (state == RETURN || state == CHANGE) begin
                change_en <= 1;
                left_coin <= state == RETURN ? coin_counter : coin_counter - 15;

                if (left_coin > 10) begin
                    change <= 2'b10;
                    coin_counter <= coin_counter - 10;
                    change_finished <= 0;
                end else if (left_coin == 10) begin
                    change <= 2'b10;
                    coin_counter <= coin_counter - 10;
                    change_finished <= 1;
                end else if (left_coin == 5) begin
                    change <= 2'b01;
                    coin_counter <= coin_counter - 5;
                    change_finished <= 1;
                end else if (left_coin == 0) begin
                    change <= 2'b00;
                    change_finished <= 1;
                end else begin  // error
                    change <= 2'b00;
                    change_finished <= 1;
                end
            end else begin
                change_en <= 0;
                change <= 2'b00;
                change_finished <= 0;
            end
        end
    end

endmodule
