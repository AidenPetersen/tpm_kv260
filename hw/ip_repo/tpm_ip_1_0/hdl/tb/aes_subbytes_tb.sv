`timescale 1ns / 1ps

module tb_aes_subbytes ();

    parameter CLK_HALF_PERIOD = 1;
    parameter CLK_PERIOD = CLK_HALF_PERIOD * 2;
    parameter STATE_ARRAY_DIMENSION = 4;

    logic [ 31 : 0] cycle_ctr;
    logic [ 31 : 0] error_ctr;
    logic [ 31 : 0] tc_ctr;

    logic           tb_clk;
    logic           tb_reset;
    logic           tb_valid;
    logic           tb_next_is_ready;
    logic     [7:0] tb_state_array[STATE_ARRAY_DIMENSION][STATE_ARRAY_DIMENSION];
    wire      [7:0] tb_state_array_out[STATE_ARRAY_DIMENSION][STATE_ARRAY_DIMENSION];
    wire            tb_ready;
    wire            tb_valid_out;

    // Instantiate the Device Under Test (DUT)
    aes_subbytes #(
        .STATE_ARRAY_DIMENSION(STATE_ARRAY_DIMENSION)
    ) dut (
        .clk(tb_clk),
        .reset(tb_reset),
        .valid(tb_valid),
        .next_is_ready(tb_next_is_ready),
        .state_array(tb_state_array),
        .state_array_out(tb_state_array_out),
        .ready(tb_ready),
        .valid_out(tb_valid_out)
    );

    // Clock generation
    always begin : clk_gen
        #CLK_HALF_PERIOD tb_clk = !tb_clk;
    end

    // Dump DUT state for debugging
    task dump_dut_state;
        begin
            $display("State of DUT");
            $display("------------");
            $display("Inputs:");
            $display("valid = %b, next_is_ready = %b", dut.valid, dut.next_is_ready);
            
            $display("Input state array:");
            for (int i = 0; i < STATE_ARRAY_DIMENSION; i++) begin
                $write("Row %0d: ", i);
                for (int j = 0; j < STATE_ARRAY_DIMENSION; j++) begin
                    $write("%h ", dut.state_array[i][j]);
                end
                $display("");
            end
            
            $display("Output state array:");
            for (int i = 0; i < STATE_ARRAY_DIMENSION; i++) begin
                $write("Row %0d: ", i);
                for (int j = 0; j < STATE_ARRAY_DIMENSION; j++) begin
                    $write("%h ", dut.state_array_out[i][j]);
                end
                $display("");
            end
            
            $display("Control signals:");
            $display("ready = %b, valid_out = %b", dut.ready, dut.valid_out);
            $display("state = %s", dut.state.name());
            $display("current_word_coords = [%0d][%0d]", dut.current_word_coords[0], dut.current_word_coords[1]);
            $display("");
        end
    endtask

    // Reset the DUT
    task reset_dut;
        begin
            tb_reset = 1;
            #(4 * CLK_HALF_PERIOD);
            tb_reset = 0;
        end
    endtask

    // Initialize the test
    task init;
        begin
            error_ctr = 0;
            tc_ctr = 0;

            tb_clk = 0;
            tb_reset = 0;
            tb_valid = 0;
            tb_next_is_ready = 1;
            
            // Initialize state array with zeros
            for (int i = 0; i < STATE_ARRAY_DIMENSION; i++) begin
                for (int j = 0; j < STATE_ARRAY_DIMENSION; j++) begin
                    tb_state_array[i][j] = 8'h00;
                end
            end
        end
    endtask

    // Display test results
    task display_test_result;
        begin
            if (error_ctr == 0) begin
                $display("*** All test cases completed successfully (%0d tests)", tc_ctr);
            end else begin
                $display("*** %02d test cases did not complete successfully.", error_ctr);
            end
        end
    endtask

    // Wait for ready signal
    task wait_ready;
        begin
            while (!tb_ready) begin
                #(CLK_PERIOD);
            end
        end
    endtask

    // Wait for valid_out signal
    task wait_valid_out;
        begin
            while (!tb_valid_out) begin
                #(CLK_PERIOD);
            end
        end
    endtask

    // Single state array test
    task subbytes_test(
        input [7 : 0] tc_number,
        input [7 : 0] in_state[STATE_ARRAY_DIMENSION][STATE_ARRAY_DIMENSION],
        input [7 : 0] expected[STATE_ARRAY_DIMENSION][STATE_ARRAY_DIMENSION]
    );
        logic error;
        begin
            $display("*** TC %0d SubBytes test case started.", tc_number);
            tc_ctr = tc_ctr + 1;
            error = 0;

            // Copy input state
            for (int i = 0; i < STATE_ARRAY_DIMENSION; i++) begin
                for (int j = 0; j < STATE_ARRAY_DIMENSION; j++) begin
                    tb_state_array[i][j] = in_state[i][j];
                end
            end

            // Start processing
            wait_ready();
            tb_valid = 1;
            #(CLK_PERIOD);
            tb_valid = 0;
            
            // Wait for processing to complete
            wait_valid_out();
            
            // Verify the results
            for (int i = 0; i < STATE_ARRAY_DIMENSION; i++) begin
                for (int j = 0; j < STATE_ARRAY_DIMENSION; j++) begin
                    if (tb_state_array_out[i][j] !== expected[i][j]) begin
                        $display("*** ERROR: TC %0d - Mismatch at position [%0d][%0d]", tc_number, i, j);
                        $display("    Expected: 0x%02x", expected[i][j]);
                        $display("    Got:      0x%02x", tb_state_array_out[i][j]);
                        error = 1;
                    end
                end
            end

            if (error) begin
                error_ctr = error_ctr + 1;
                $display("*** TC %0d NOT successful.", tc_number);
            end else begin
                $display("*** TC %0d successful.", tc_number);
            end
            $display("");

            // Signal that we're ready for the next test
            tb_next_is_ready = 1;
            #(CLK_PERIOD);
        end
    endtask

    // Main test program
    initial begin : aes_subbytes_test
        // Test data
        logic [7:0] tc1_input[STATE_ARRAY_DIMENSION][STATE_ARRAY_DIMENSION];
        logic [7:0] tc1_expected[STATE_ARRAY_DIMENSION][STATE_ARRAY_DIMENSION];
        logic [7:0] tc2_input[STATE_ARRAY_DIMENSION][STATE_ARRAY_DIMENSION];
        logic [7:0] tc2_expected[STATE_ARRAY_DIMENSION][STATE_ARRAY_DIMENSION];

        init();
        dump_dut_state();
        reset_dut();
        dump_dut_state();

        // TC1: Simple test with all zeros
        for (int i = 0; i < STATE_ARRAY_DIMENSION; i++) begin
            for (int j = 0; j < STATE_ARRAY_DIMENSION; j++) begin
                tc1_input[i][j] = 8'h00;
                tc1_expected[i][j] = 8'h63; // S-box value for 0x00 is 0x63
            end
        end
        subbytes_test(1, tc1_input, tc1_expected);
        dump_dut_state();

        // TC2: Test with sample AES state
        tc2_input = '{
            '{8'h19, 8'ha0, 8'h9a, 8'he9},
            '{8'h3d, 8'hf4, 8'hc6, 8'hf8},
            '{8'he3, 8'he2, 8'h8d, 8'h48},
            '{8'hbe, 8'h2b, 8'h2a, 8'h08}
        };
        
        // Apply S-box transformation to each byte
        tc2_expected = '{
            '{8'hd4, 8'he0, 8'hb8, 8'h1e},
            '{8'h27, 8'hbf, 8'hb4, 8'h41},
            '{8'h11, 8'h98, 8'h5d, 8'h52},
            '{8'hae, 8'hf1, 8'he5, 8'h30}
        };
        
        subbytes_test(2, tc2_input, tc2_expected);
        dump_dut_state();


        display_test_result();
        $finish;
    end
endmodule