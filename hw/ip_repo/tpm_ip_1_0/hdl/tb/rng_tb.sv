`timescale 1ns / 1ps
module rng_tb;
    logic clk;
    logic rst;
    logic start;

    logic [8 * 8 - 1:0] result;
    logic valid;
    
    rng rng_inst(
        .clk(clk),
        .rst(rst),
        .start(start),
        .result(result),
        .valid(valid)
    );
    
    initial begin
        clk = 0;
        forever begin
        #10 clk = ~clk;
        end
    end
    
    initial begin
        rst = 1;
        #15;
        rst = 0;
        #10
        start <= 1;
        #10
        start <= 0;
        #200
        start <= 1;
    end
    
    
endmodule