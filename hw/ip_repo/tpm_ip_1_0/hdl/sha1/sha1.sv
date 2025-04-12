
`timescale 1ns / 1ps

// SHA1 core that accepts preprocessed
// 512-bit chunks
module sha1 (
    input  wire           clk,
    input  wire           reset_n,
    input  wire           init,
    input  wire           next,
    input  wire [511 : 0] chunk,
    output wire           ready,
    output wire [159 : 0] out_digest,
    output wire           out_valid
);

    // Define our SHA1 constant initializers
    parameter H0_0 = 32'h67452301;
    parameter H0_1 = 32'hefcdab89;
    parameter H0_2 = 32'h98badcfe;
    parameter H0_3 = 32'h10325476;
    parameter H0_4 = 32'hc3d2e1f0;


    typedef enum {
        STATE_IDLE,
        STATE_RUNNING,
        STATE_DONE
    } state_t;



    // Registers
    logic   [ 6 : 0] round_counter_reg;

    logic   [31 : 0] a_reg;
    logic   [31 : 0] b_reg;
    logic   [31 : 0] c_reg;
    logic   [31 : 0] d_reg;
    logic   [31 : 0] e_reg;

    logic   [31 : 0] H0_reg;
    logic   [31 : 0] H1_reg;
    logic   [31 : 0] H2_reg;
    logic   [31 : 0] H3_reg;
    logic   [31 : 0] H4_reg;


    wire    [31 : 0] w;
    logic   [31 : 0] w_mem                      [16];


    logic            digest_valid_reg;
    state_t          current_state;


    // Combinatorial Variables

    logic   [ 6 : 0] round_counter_next;
    logic            round_counter_increment;
    logic            round_counter_rst;

    logic   [31 : 0] a_next;
    logic   [31 : 0] b_next;
    logic   [31 : 0] c_next;
    logic   [31 : 0] d_next;
    logic   [31 : 0] e_next;

    logic            digest_valid_next;


    logic   [31 : 0] H0_next;
    logic   [31 : 0] H1_next;
    logic   [31 : 0] H2_next;
    logic   [31 : 0] H3_next;
    logic   [31 : 0] H4_next;

    logic   [31 : 0] w_mem_next                 [16];

    logic   [31 : 0] w_tmp;
    logic   [31 : 0] w_next;

    state_t          next_state;

    logic            digest_init;
    logic            digest_update;
    logic            state_init;
    logic            update_vals;
    logic            first_chunk;
    logic            ready_flag;
    logic            w_init;
    logic            update_w;

    // Write enables
    logic            round_counter_write_enable;
    logic            a_e_we;
    logic            next_state_we;
    logic            H_we;
    logic            digest_valid_we;
    logic            w_mem_we;








    //---------------------------
    // Begin dataflow assignments
    //---------------------------

    assign w          = w_tmp;
    assign ready      = ready_flag;
    assign out_digest = {H0_reg, H1_reg, H2_reg, H3_reg, H4_reg};
    assign out_valid  = digest_valid_reg;


    //---------------------------
    // Begin sequential logic
    //---------------------------

    // Main sequential process,
    // in charge of updating register state for all
    // registers
    always_ff @(posedge clk or negedge reset_n) begin : reg_update
        integer i;

        if (!reset_n) begin
            for (i = 0; i < 16; i = i + 1) w_mem[i] <= 32'h0;


            a_reg             <= 32'h0;
            b_reg             <= 32'h0;
            c_reg             <= 32'h0;
            d_reg             <= 32'h0;
            e_reg             <= 32'h0;
            H0_reg            <= 32'h0;
            H1_reg            <= 32'h0;
            H2_reg            <= 32'h0;
            H3_reg            <= 32'h0;
            H4_reg            <= 32'h0;
            digest_valid_reg  <= 1'h0;
            round_counter_reg <= 7'h0;
            current_state     <= STATE_IDLE;
        end else begin
            if (w_mem_we) begin
                for (int i = 0; i < $size(w_mem); i++) begin
                    w_mem[i] <= w_mem_next[i];
                end

            end

            if (a_e_we) begin
                a_reg <= a_next;
                b_reg <= b_next;
                c_reg <= c_next;
                d_reg <= d_next;
                e_reg <= e_next;
            end

            if (H_we) begin
                H0_reg <= H0_next;
                H1_reg <= H1_next;
                H2_reg <= H2_next;
                H3_reg <= H3_next;
                H4_reg <= H4_next;
            end

            if (round_counter_write_enable) begin
                round_counter_reg <= round_counter_next;
            end

            if (digest_valid_we) begin
                digest_valid_reg <= digest_valid_next;
            end

            if (next_state_we) begin
                current_state <= next_state;
            end

        end
    end


    //---------------------------
    // Begin combinatorial logic
    //---------------------------

    always_comb begin : round_counter
        round_counter_next = 7'h0;
        round_counter_write_enable = 1'h0;

        if (round_counter_rst) begin
            round_counter_next = 7'h0;
            round_counter_write_enable = 1'h1;
        end

        if (round_counter_increment) begin
            round_counter_next = round_counter_reg + 1'h1;
            round_counter_write_enable = 1;
        end
    end

    always_comb begin : digest_logic
        H0_next = 32'h0;
        H1_next = 32'h0;
        H2_next = 32'h0;
        H3_next = 32'h0;
        H4_next = 32'h0;
        H_we = 0;

        if (digest_init) begin
            H0_next = H0_0;
            H1_next = H0_1;
            H2_next = H0_2;
            H3_next = H0_3;
            H4_next = H0_4;
            H_we = 1;
        end

        if (digest_update) begin
            H0_next = H0_reg + a_reg;
            H1_next = H1_reg + b_reg;
            H2_next = H2_reg + c_reg;
            H3_next = H3_reg + d_reg;
            H4_next = H4_reg + e_reg;
            H_we = 1;
        end
    end

    always_comb begin : select_w
        if (round_counter_reg < 16) begin
            w_tmp = w_mem[round_counter_reg[3 : 0]];
        end else begin
            w_tmp = w_next;
        end
    end

    always_comb begin : w_mem_update_logic
        logic [31 : 0] w_0;
        logic [31 : 0] w_2;
        logic [31 : 0] w_8;
        logic [31 : 0] w_13;
        logic [31 : 0] w_16;

        for (int i = 0; i < $size(w_mem_next); i++) begin
            w_mem_next[i] = 32'h0;
        end

        w_mem_we    = 1'h0;

        w_0   = w_mem[0];
        w_2   = w_mem[2];
        w_8   = w_mem[8];
        w_13  = w_mem[13];
        w_16  = w_13 ^ w_8 ^ w_2 ^ w_0;
        w_next = {w_16[30 : 0], w_16[31]};

        if (init) begin
            for (int i = 0; i < $size(w_mem_next); i++) begin
                w_mem_next[i] = chunk[511-i*32-:32];
            end
            w_mem_we = 1'h1;
        end

        if (update_w && (round_counter_reg > 15)) begin
            for (int i = 0; i < $size(w_mem_next) - 1; i++) begin
                w_mem_next[i] = w_mem[i+1];
            end
            w_mem_next[15] = w_next;
            w_mem_we    = 1'h1;
        end
    end

    always_comb begin : state_logic
        logic [31 : 0] a5;
        logic [31 : 0] f;
        logic [31 : 0] k;
        logic [31 : 0] t;

        a5     = 32'h0;
        f      = 32'h0;
        k      = 32'h0;
        t      = 32'h0;
        a_next = 32'h0;
        b_next = 32'h0;
        c_next = 32'h0;
        d_next = 32'h0;
        e_next = 32'h0;
        a_e_we = 1'h0;

        if (state_init) begin
            if (first_chunk) begin
                a_next = H0_0;
                b_next = H0_1;
                c_next = H0_2;
                d_next = H0_3;
                e_next = H0_4;
                a_e_we = 1;
            end else begin
                a_next = H0_reg;
                b_next = H1_reg;
                c_next = H2_reg;
                d_next = H3_reg;
                e_next = H4_reg;
                a_e_we = 1;
            end
        end

        if (update_vals) begin
            if (round_counter_reg <= 19) begin
                k = 32'h5a827999;
                f = ((b_reg & c_reg) ^ (~b_reg & d_reg));
            end else if ((round_counter_reg >= 20) && (round_counter_reg <= 39)) begin
                k = 32'h6ed9eba1;
                f = b_reg ^ c_reg ^ d_reg;
            end else if ((round_counter_reg >= 40) && (round_counter_reg <= 59)) begin
                k = 32'h8f1bbcdc;
                f = ((b_reg | c_reg) ^ (b_reg | d_reg) ^ (c_reg | d_reg));
            end else if (round_counter_reg >= 60) begin
                k = 32'hca62c1d6;
                f = b_reg ^ c_reg ^ d_reg;
            end

            a5 = {a_reg[26 : 0], a_reg[31 : 27]};
            t = a5 + e_reg + f + k + w;

            a_next = t;
            b_next = a_reg;
            c_next = {b_reg[1 : 0], b_reg[31 : 2]};
            d_next = c_reg;
            e_next = d_reg;
            a_e_we = 1;
        end
    end

    always_comb begin : state_fsm


        digest_init             = 1'h0;
        digest_update           = 1'h0;
        state_init              = 1'h0;
        update_vals             = 1'h0;
        first_chunk             = 1'h0;
        ready_flag              = 1'h0;
        w_init                  = 1'h0;
        update_w                = 1'h0;
        round_counter_increment = 1'h0;
        round_counter_rst       = 1'h0;
        digest_valid_next       = 1'h0;
        digest_valid_we         = 1'h0;
        next_state              = STATE_IDLE;
        next_state_we           = 1'h0;


        unique case (current_state)
            STATE_IDLE: begin
                ready_flag = 1;

                if (init) begin
                    digest_init       = 1'h1;
                    w_init            = 1'h1;
                    state_init        = 1'h1;
                    first_chunk       = 1'h1;
                    round_counter_rst = 1'h1;
                    digest_valid_next = 1'h0;
                    digest_valid_we   = 1'h1;
                    next_state        = STATE_RUNNING;
                    next_state_we     = 1'h1;
                end

                if (next) begin
                    w_init            = 1'h1;
                    state_init        = 1'h1;
                    round_counter_rst = 1'h1;
                    digest_valid_next = 1'h0;
                    digest_valid_we   = 1'h1;
                    next_state        = STATE_RUNNING;
                    next_state_we     = 1'h1;
                end
            end


            STATE_RUNNING: begin
                update_vals             = 1'h1;
                round_counter_increment = 1'h1;
                update_w                = 1'h1;

                // Hard-coded to 80 rounds
                // TODO make this either a parameter or an input
                if (round_counter_reg == 7'd79) begin
                    next_state = STATE_DONE;
                    next_state_we = 1'h1;
                end
            end


            STATE_DONE: begin
                digest_update     = 1'h1;
                digest_valid_next = 1'h1;
                digest_valid_we   = 1'h1;
                next_state        = STATE_IDLE;
                next_state_we     = 1'h1;
            end
        endcase  // case (current_state)
    end

endmodule
