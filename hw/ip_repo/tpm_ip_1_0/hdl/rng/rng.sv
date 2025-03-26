`timescale 1ns / 1ps
// Accumulates bytes from rng_stream
module rng
#(
parameter BYTES = 8,
parameter STREAM_BYTES = 8
)
(
    input logic clk,
    input logic rst,
    input logic start,

    output logic [8 * BYTES - 1:0]result,
    output logic valid
);
    logic [$clog2(BYTES):0]counter;
    logic stream_enable;
    logic [STREAM_BYTES - 1:0]stream_out;
    
    assign stream_enable = start || (counter < BYTES);
    
    rng_stream stream_inst(
        .clk(clk),
        .rst(rst),
        .enable(stream_enable),
        .data_out(stream_out)
    );
    
    always@(posedge clk) begin
        if (rst) begin
            counter <= 0;
            result <= 0;
            valid <= 0;
        end
        else begin
            // being running, wait a cycle to grab from stream
            if(counter == 0 && start) begin
                valid <= 0;
                counter <= 1;
            end
            else if (counter > 0 && counter <= BYTES) begin
                counter <= counter + 1;
                result[BYTES * counter - 1 -: BYTES] <= stream_out;
            end 
            else if (counter == BYTES + 1) begin
                counter <= 0;
                valid <= 1;
            end
        end
    end
endmodule
