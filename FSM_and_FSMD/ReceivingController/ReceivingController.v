`timescale 1ns / 1ps

// receive serial data from a data bus
//  - Baud rate: 115200
//  - system clock: 10MHz
//  - assume 1 bit / cycle
//  - 1 start bit, 4 dst bits, 4 src bits, 8 data bits, 3 CRC bits, 1 stop bit
//  - if dst iD == node_id, store data in Doutï¼?
//    generate CRC, compare CRC, set done or error
module ReceivingController(
        input clk,
        input rst,
        input Din,
        input [3:0] node_id,
        output reg [7:0] Dout,
        output reg error,
        output reg done
    );

    reg [3:0] dst_id, src_id;
    reg [7:0] data;
    reg [2:0] crc, crc_gen;
    reg crc_en;

    // state
    localparam IDLE = 3'b000;
    localparam DST = 3'b001;
    localparam SRC = 3'b010;
    localparam DATA = 3'b011;
    localparam CRC = 3'b100;
    localparam STOP = 3'b101;

    reg [2:0] state, next_state;

    // counter
    reg [3:0] counter;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            state <= IDLE;
            counter <= 0;
            error <= 0;
            done <= 0;
            Dout <= 0;
            crc_en <= 0;
        end else begin
            state <= next_state;
            if (state == IDLE)
                counter <= 0;
            else
                counter <= counter + 1;
        end
    end

    // next state logic
    always @(*) begin
        next_state = state;
        if (error == 0 && done == 0) begin
            case (state)
                IDLE: begin
                    if (Din == 1'b0)
                        next_state = DST;
                end
                DST: begin
                    if (counter <= 3) begin
                        dst_id = {Din, dst_id[3:1]};
                    end
                    if (counter == 3) begin
                        if (dst_id == node_id) begin
                            next_state = SRC;
                        end else begin
                            error = 1;
                            next_state = IDLE;
                        end
                    end
                end
                SRC: begin
                    if (counter <= 7) begin
                        src_id = {Din, src_id[3:1]};
                    end
                    if (counter == 7) begin
                        next_state = DATA;
                    end
                end
                DATA: begin
                    if (counter <= 15) begin
                        data = {Din, data[7:1]};
                    end
                    if (counter == 15) begin
                        next_state = DATA;
                    end
                end
                CRC: begin
                    if (counter <= 18) begin
                        crc = {Din, crc[2:1]};
                    end
                    if (counter == 18) begin
                        next_state = STOP;
                        crc_en = 1;
                    end
                end
                STOP: begin
                    if (counter == 19) begin
                        if (Din == 1'b0) begin
                            next_state = IDLE;
                            done = 1;
                        end else begin
                            error = 1;
                            next_state = IDLE;
                        end
                        counter <= 0;
                    end else begin
                        error = 1;
                        next_state = IDLE;
                        counter <= 0;
                    end
                end
            endcase
        end
    end

    // assume that we already have a CRC generator "CRC3"
    CRC3 crc_check(crc_en, {dst_id, src_id, data}, crc_gen);

    always @(*) begin
        if (state == STOP) begin
            if (crc_gen == crc)
                Dout <= data;
            else
                error = 1;
        end
    end

endmodule

module CRC3(
        input enable,
        input [15:0] data,
        output reg [2:0] crc
    );

    // TODO: implement CRC3

endmodule