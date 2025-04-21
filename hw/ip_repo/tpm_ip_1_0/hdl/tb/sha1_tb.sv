`timescale 1ns / 1ps

module tb_sha1 ();



    parameter CLK_HALF_PERIOD = 1;
    parameter CLK_PERIOD = CLK_HALF_PERIOD * 2;


    logic [ 31 : 0] cycle_ctr;
    logic [ 31 : 0] error_ctr;
    logic [ 31 : 0] tc_ctr;

    logic           tb_clk;
    logic           tb_reset_n;
    logic           tb_init;
    logic           tb_next;
    logic [511 : 0] tb_block;
    wire            tb_ready;
    wire  [159 : 0] tb_digest;
    wire            tb_digest_valid;

    sha1 dut (
        .clk(tb_clk),
        .reset_n(tb_reset_n),

        .init(tb_init),
        .next(tb_next),

        .chunk(tb_block),

        .ready(tb_ready),

        .out_digest(tb_digest),
        .out_valid (tb_digest_valid)
    );


    always begin : clk_gen
        #CLK_HALF_PERIOD tb_clk = !tb_clk;
    end

    task dump_dut_state;
        begin
            $display("State of DUT");
            $display("------------");
            $display("Inputs and outputs:");
            $display("init   = 0x%01x, next  = 0x%01x", dut.init, dut.next);
            $display("block  = 0x%0128x", dut.chunk);

            $display("ready  = 0x%01x, valid = 0x%01x", dut.ready, dut.out_valid);
            $display("digest = 0x%040x", dut.out_digest);
            $display(
                "H0_reg = 0x%08x, H1_reg = 0x%08x, H2_reg = 0x%08x, H3_reg = 0x%08x, H4_reg = 0x%08x",
                dut.H0_reg, dut.H1_reg, dut.H2_reg, dut.H3_reg, dut.H4_reg);
            $display("");

            $display("Control signals and counter:");
            $display("current_state = 0x%01x", dut.current_state);
            $display("digest_init   = 0x%01x, digest_update = 0x%01x", dut.digest_init,
                     dut.digest_update);
            $display("state_init    = 0x%01x, update_vals  = 0x%01x", dut.state_init,
                     dut.update_vals);
            $display("first_block   = 0x%01x, ready_flag    = 0x%01x, w_init        = 0x%01x",
                     dut.first_chunk, dut.ready_flag, dut.w_init);
            $display("round_ctr_inc = 0x%01x, round_ctr_rst = 0x%01x, round_counter_reg = 0x%02x",
                     dut.round_counter_increment, dut.round_counter_rst, dut.round_counter_reg);
            $display("");

            $display("State registers:");
            $display(
                "a_reg = 0x%08x, b_reg = 0x%08x, c_reg = 0x%08x, d_reg = 0x%08x, e_reg = 0x%08x",
                dut.a_reg, dut.b_reg, dut.c_reg, dut.d_reg, dut.e_reg);
            $display(
                "a_next = 0x%08x, b_next = 0x%08x, c_next = 0x%08x, d_next = 0x%08x, e_next = 0x%08x",
                dut.a_next, dut.b_next, dut.c_next, dut.d_next, dut.e_next);
            $display("");

            $display("State update values:");
            $display("f = 0x%08x, k = 0x%08x, t = 0x%08x, w = 0x%08x,", dut.state_logic.f,
                     dut.state_logic.k, dut.state_logic.t, dut.w);
            $display("");
        end
    endtask

    task reset_dut;
        begin
            tb_reset_n = 0;
            #(4 * CLK_HALF_PERIOD);
            tb_reset_n = 1;
        end
    endtask

    task init;
        begin
            error_ctr = 0;
            tc_ctr = 0;

            tb_clk = 0;
            tb_reset_n = 1;

            tb_init = 0;
            tb_next = 0;
            tb_block = 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        end
    endtask


    task display_test_result;
        begin
            if (error_ctr == 0) begin
                $display("*** All test cases completed successfully", tc_ctr);
            end else begin
                $display("*** %02d test cases did not complete successfully.", error_ctr);
            end
        end
    endtask


    task wait_ready;
        begin
            while (!tb_ready) begin
                #(CLK_PERIOD);

            end
        end
    endtask


    task single_block_test(input [7 : 0] tc_number, input [511 : 0] block,
                           input [159 : 0] expected);
        begin
            $display("*** TC %0d single block test case started.", tc_number);
            tc_ctr   = tc_ctr + 1;

            tb_block = block;
            tb_init  = 1;
            #(CLK_PERIOD);
            tb_init = 0;
            wait_ready();


            if (tb_digest == expected) begin
                $display("*** TC %0d successful.", tc_number);
                $display("");
            end else begin
                $display("*** ERROR: TC %0d NOT successful.", tc_number);
                $display("Expected: 0x%040x", expected);
                $display("Got:      0x%040x", tb_digest);
                $display("");

                error_ctr = error_ctr + 1;
            end
        end
    endtask

    task double_block_test(input [7 : 0] tc_number, input [511 : 0] block1,
                           input [159 : 0] expected1, input [511 : 0] block2,
                           input [159 : 0] expected2);

        logic [159 : 0] db_digest1;
        logic           db_error;
        begin
            $display("*** TC %0d double block test case started.", tc_number);
            db_error = 0;
            tc_ctr   = tc_ctr + 1;

            $display("*** TC %0d first block started.", tc_number);
            tb_block = block1;
            tb_init  = 1;
            #(CLK_PERIOD);
            tb_init = 0;
            wait_ready();
            db_digest1 = tb_digest;
            $display("*** TC %0d first block done.", tc_number);
            #(CLK_PERIOD)
            #(CLK_PERIOD)
            #(CLK_PERIOD)
            #(CLK_PERIOD)
            #(CLK_PERIOD)
            #(CLK_PERIOD)
            #(CLK_PERIOD)

            $display("*** TC %0d second block started.", tc_number);
            tb_block = block2;
            tb_next  = 1;
            #(CLK_PERIOD);
            tb_next = 0;
            wait_ready();
            $display("*** TC %0d second block done.", tc_number);

            if (db_digest1 == expected1) begin
                $display("*** TC %0d first block successful", tc_number);
                $display("");
            end else begin
                $display("*** ERROR: TC %0d first block NOT successful", tc_number);
                $display("Expected: 0x%040x", expected1);
                $display("Got:      0x%040x", db_digest1);
                $display("");
                db_error = 1;
            end

            if (db_digest1 == expected1) begin
                $display("*** TC %0d second block successful", tc_number);
                $display("");
            end else begin
                $display("*** ERROR: TC %0d second block NOT successful", tc_number);
                $display("Expected: 0x%040x", expected2);
                $display("Got:      0x%040x", tb_digest);
                $display("");
                db_error = 1;
            end

            if (db_error) begin
                error_ctr = error_ctr + 1;
            end
        end
    endtask


    //----------------------------------------------------------------
    // The main test functionality.
    //
    // Test cases taken from:
    // http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA_All.pdf
    //----------------------------------------------------------------
    initial begin : sha1_test
        logic [511 : 0] tc1;
        logic [159 : 0] res1;

        logic [511 : 0] tc2_1;
        logic [159 : 0] res2_1;
        logic [511 : 0] tc2_2;
        logic [159 : 0] res2_2;

        init();
        dump_dut_state();
        reset_dut();
        dump_dut_state();

        // TC1: Single block message: "abc".
        tc1 = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
        res1 = 160'ha9993e364706816aba3e25717850c26c9cd0d89d;
        single_block_test(1, tc1, res1);

        // TC2: Double block message.
        // "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
        tc2_1 = 512'h6162636462636465636465666465666765666768666768696768696A68696A6B696A6B6C6A6B6C6D6B6C6D6E6C6D6E6F6D6E6F706E6F70718000000000000000;
        res2_1 = 160'hf4286818c37b27ae0408f581846771484a566572;

        tc2_2 = 512'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001C0;
        res2_2 = 160'h84983e441c3bd26ebaae4aa1f95129e5e54670f1;
        double_block_test(2, tc2_1, res2_1, tc2_2, res2_2);

        display_test_result();
        $finish;
    end
endmodule

