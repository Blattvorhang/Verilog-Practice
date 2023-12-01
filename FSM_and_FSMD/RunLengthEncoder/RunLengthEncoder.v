`timescale 1ns / 1ps

module RunLengthEncoder(
        input [7:0] in,
        input clk,
        output reg [15:0] out,
        output reg valid
    );

    // 8-bit input stream
    // 16-bit output stream
    //  - 8 high-order bits: data value
    //  - 8 low-order bits: repeat count of previous data value
    // valid: 16-bit output is valid or under-counting
    // take care of overflow

    reg [7:0] current_data;
    reg [7:0] repeat_count;

    initial begin
        current_data = 0;
        repeat_count = 0;
        valid = 0;
    end

    always @(posedge clk) begin
        out <= {current_data, repeat_count};
        if (in == current_data) begin
            if (repeat_count == 255) begin
                repeat_count <= 1;
                valid <= 1;
            end else begin
                repeat_count <= repeat_count + 1;
                valid <= 0;
            end
        end else begin
            valid <= 1;
            current_data <= in;
            repeat_count <= 1;
        end
    end

endmodule
