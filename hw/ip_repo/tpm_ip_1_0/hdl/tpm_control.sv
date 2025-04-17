`timescale 1ns / 1ps

// Controls execution of different accelerators and mem based on slave configuration regs
module tpm_control #(
    parameter C_SHA_CHUNK_SIZE = 512,
    parameter C_SHA_DIGEST_SIZE = 160,
    parameter C_RNG_SIZE = 32,
    parameter C_REG_SIZE = 32
)(
    input logic clk,
    input logic resetn,
    // slv regs 0-8
    // In status spec:
    // [0] ready
    // [5:1] opcode
    input logic [C_REG_SIZE-1:0] in_status,
    input logic [C_REG_SIZE-1:0] in_arg0,
    input logic [C_REG_SIZE-1:0] in_arg1,
    input logic [C_REG_SIZE-1:0] in_arg2,
    input logic [C_REG_SIZE-1:0] in_arg3,
    input logic [C_REG_SIZE-1:0] in_arg4,
    input logic [C_REG_SIZE-1:0] in_arg5,
    input logic [C_REG_SIZE-1:0] in_arg6,
    input logic [C_REG_SIZE-1:0] in_arg7,

    // slv regs 64-72
    // Out status spec:
    // [0] ready or not
    // [1] out valid
    output logic [C_REG_SIZE-1:0] out_status,
    output logic [C_REG_SIZE-1:0] out_arg0,
    output logic [C_REG_SIZE-1:0] out_arg1,
    output logic [C_REG_SIZE-1:0] out_arg2,
    output logic [C_REG_SIZE-1:0] out_arg3,
    output logic [C_REG_SIZE-1:0] out_arg4,
    output logic [C_REG_SIZE-1:0] out_arg5,
    output logic [C_REG_SIZE-1:0] out_arg6,
    output logic [C_REG_SIZE-1:0] out_arg7,

    // Signal to reset in status to prevent looping.
    output logic reset_status
    );
    // Internal Signals
    // SHA signals
    logic [C_SHA_CHUNK_SIZE-1:0] sha_block;
    logic [C_SHA_DIGEST_SIZE-1:0] sha_digest;

    // RNG signals
    logic [C_RNG_SIZE-1:0] rng_result;
    logic rng_start;
    logic rng_valid;

    
    logic [3:0] state;
    logic valid;

    // Decode logic
    logic [4:0] opcode;
    assign opcode = in_status[5:1];
    logic input_valid;
    assign input_valid = in_status[0];

    localparam
        RNG_opcode=0, 
        SHA_opcode=1;

    localparam 
        Idle=0, 
        SHA_Load1=1, SHA_Load2=2, SHA_Wait=3, SHA_Complete=4,
        RNG_Wait=5;
     

    assign out_status[0] = state == Idle;
    assign out_status[1] = valid;
    
    // Modules
    rng #(
        .BYTES(C_RNG_SIZE/8)
    ) rng_inst (
        .clk(clk),
        .rst(resetn),
        .start(rng_start),
        .result(rng_result),
        .valid(rng_valid)
    );

    // Control logic
    always_ff @( posedge clk ) begin
        if(resetn) begin
            // Reset outputs
            out_status[31:2] <= 0;
            out_arg0 <= 0;
            out_arg1 <= 0;
            out_arg2 <= 0;
            out_arg3 <= 0;
            out_arg4 <= 0;
            out_arg5 <= 0;
            out_arg6 <= 0;
            out_arg7 <= 0;
            reset_status <= 0;

            // SHA signals
            sha_block <= 0;
            sha_digest <= 0;

            // RNG signals
            rng_start <= 0;

            // Output control
            valid <= 0;
            state <= Idle;
        end
        
        else if(state == Idle) begin
            if(input_valid) begin
                valid <= 0;

                // START RNG
                if(opcode == RNG_opcode) begin
                    state <= RNG_Wait;
                    rng_start <= 1;
                    reset_status <= 1;
                end
            end
        end 
        else if(state == RNG_Wait) begin
            reset_status <= 0;
            rng_start <= 0;
            if(rng_valid) begin
                state <= Idle;
                out_arg0 <= rng_result;
                valid <= 1;
            end
        end
    end


endmodule
