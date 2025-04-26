`timescale 1ns / 1ps

module aes_shiftrows #(
    parameter int unsigned STATE_ARRAY_DIMENSION = 4
) (
    input wire logic clk,
    input wire logic reset,

    input wire logic valid,
    input wire logic next_is_ready,

    input  logic [7:0] state_array    [STATE_ARRAY_DIMENSION][STATE_ARRAY_DIMENSION],
    output logic [7:0] state_array_out[STATE_ARRAY_DIMENSION][STATE_ARRAY_DIMENSION],

    output wire logic ready,
    output wire logic valid_out
);

    assign ready = next_is_ready;
    assign valid_out = valid;

    genvar row;
    genvar column;
    generate
        for (row = 0; row < STATE_ARRAY_DIMENSION; row++) begin : gen_row_shifter
            for (column = 0; column < STATE_ARRAY_DIMENSION; column++) begin : gen_byte_shifter
                if (column - row < 0) begin
                    assign state_array_out[row][column - row + STATE_ARRAY_DIMENSION] = state_array[row][column];
                end else begin
                    assign state_array_out[row][column-row] = state_array[row][column];
                end
            end
        end
    endgenerate

endmodule
