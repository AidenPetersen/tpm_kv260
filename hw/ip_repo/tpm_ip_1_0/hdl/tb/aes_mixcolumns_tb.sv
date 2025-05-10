module aes_mixcolumns_tb;
    // Timeunit and timeprecision declarations
    timeunit 1ns;
    timeprecision 1ps;

    // Input and output 2D arrays
    logic [7:0] state_in[4][4];
    logic [7:0] state_out[4][4];
    
    // Expected output for verification
    logic [7:0] expected_state[4][4];
    
    // Instantiate the module under test
    aes_mixcolumns uut (
        .state_in(state_in),
        .state_out(state_out)
    );
    
    // Helper function to display state in a matrix format
    function automatic void display_state(
        input logic [7:0] state[4][4],
        input string name
    );
        $display("%s:", name);
        foreach (state[r]) begin
            $write("Row %0d: ", r);
            foreach (state[r][c]) begin
                $write("%h ", state[r][c]);
            end
            $display();
        end
        $display();
    endfunction
    
    // Galois field multiplication function
    // (Verified against correct software implementation)
    function automatic logic [7:0] gmul(
        input logic [7:0] a,
        input logic [7:0] b
    );
        logic [7:0] p = 0;
        for (int i = 0; i < 8; i++) begin
            if (b[0]) 
                p ^= a;
                
            // Check if high bit is set and update accordingly
            a = (a[7]) ? ((a << 1) ^ 8'h1b) : (a << 1);
            b >>= 1;
        end
        return p;
    endfunction
    
    // Calculate mixed column result
    function automatic void mix_single_column(
        input logic [7:0] col_in[4],
        output logic [7:0] col_out[4]
    );
        col_out[0] = gmul(8'h02, col_in[0]) ^ gmul(8'h03, col_in[1]) ^ 
                     col_in[2] ^ col_in[3];
                     
        col_out[1] = col_in[0] ^ gmul(8'h02, col_in[1]) ^ 
                     gmul(8'h03, col_in[2]) ^ col_in[3];
                     
        col_out[2] = col_in[0] ^ col_in[1] ^ 
                     gmul(8'h02, col_in[2]) ^ gmul(8'h03, col_in[3]);
                     
        col_out[3] = gmul(8'h03, col_in[0]) ^ col_in[1] ^ 
                     col_in[2] ^ gmul(8'h02, col_in[3]);
    endfunction
    
    // Calculate expected output for entire state
    function automatic void calculate_expected_output(
        input logic [7:0] in_state[4][4],
        output logic [7:0] out_state[4][4]
    );
        logic [7:0] column[4];
        logic [7:0] result[4];
        
        // For each column
        for (int c = 0; c < 4; c++) begin
            // Extract column
            for (int r = 0; r < 4; r++) begin
                column[r] = in_state[r][c];
            end
            
            // Mix the column
            mix_single_column(column, result);
            
            // Store result back by rows
            for (int r = 0; r < 4; r++) begin
                out_state[r][c] = result[r];
            end
        end
    endfunction
    
    // Verification function
    function automatic bit verify_result(
        input logic [7:0] expected[4][4],
        input logic [7:0] actual[4][4]
    );
        verify_result = 1'b1; // Assume success
        
        foreach (expected[r, c]) begin
            if (expected[r][c] !== actual[r][c]) begin
                verify_result = 1'b0; // Mismatch found
                $display("ERROR: Mismatch at [%0d][%0d], Expected: %h, Actual: %h", 
                         r, c, expected[r][c], actual[r][c]);
            end
        end
        
        if (!verify_result) begin
            $display("ERROR: Mismatch detected!");
            display_state(expected, "Expected");
            display_state(actual, "Actual");
        end
    endfunction
    
    // Test scenario typedef to organize test data
    typedef struct {
        string name;
        logic [7:0] input_state[4][4];
    } test_scenario_t;
    
    // Test cases
    initial begin
        test_scenario_t test_scenarios[$];
        test_scenario_t current_test;
        bit test_passed;
        
        // Define test scenarios
        // 1. NIST FIPS 197 Example (Appendix B)
        current_test.name = "NIST FIPS 197 Example";
        current_test.input_state = '{
            '{8'hd4, 8'he0, 8'hb8, 8'h1e},
            '{8'hbf, 8'hb4, 8'h41, 8'h27},
            '{8'h5d, 8'h52, 8'h11, 8'h98},
            '{8'h30, 8'hae, 8'hf1, 8'he5}
        };
        test_scenarios.push_back(current_test);
        
        // 2. All zeros
        current_test.name = "All Zeros";
        current_test.input_state = '{
            '{8'h00, 8'h00, 8'h00, 8'h00},
            '{8'h00, 8'h00, 8'h00, 8'h00},
            '{8'h00, 8'h00, 8'h00, 8'h00},
            '{8'h00, 8'h00, 8'h00, 8'h00}
        };
        test_scenarios.push_back(current_test);
        
        // 3. All ones
        current_test.name = "All Ones";
        current_test.input_state = '{
            '{8'hff, 8'hff, 8'hff, 8'hff},
            '{8'hff, 8'hff, 8'hff, 8'hff},
            '{8'hff, 8'hff, 8'hff, 8'hff},
            '{8'hff, 8'hff, 8'hff, 8'hff}
        };
        test_scenarios.push_back(current_test);
        
        // 4. Alternating pattern (generated procedurally)
        current_test.name = "Alternating Pattern";
        for (int r = 0; r < 4; r++) begin
            for (int c = 0; c < 4; c++) begin
                current_test.input_state[r][c] = ((r+c) % 2 == 0) ? 8'h55 : 8'haa;
            end
        end
        test_scenarios.push_back(current_test);
        
        // 5. Another standard test vector
        current_test.name = "Standard Test Vector";
        current_test.input_state = '{
            '{8'h63, 8'h9f, 8'hba, 8'h0c},
            '{8'h2f, 8'h92, 8'h0c, 8'h03},
            '{8'haf, 8'hab, 8'h03, 8'h02},
            '{8'ha2, 8'hc7, 8'h2a, 8'h2a}
        };
        test_scenarios.push_back(current_test);
        
        $display("Starting AES MixColumns Testbench (Modern SystemVerilog Style)");
        
        // Run all test scenarios
        foreach (test_scenarios[i]) begin
            // Copy the test input
            state_in = test_scenarios[i].input_state;
            
            // Wait for circuit to stabilize
            #10;
            
            // Display and verify
            $display("\nTest Case %0d: %s", i+1, test_scenarios[i].name);
            display_state(state_in, "Input State");
            
            calculate_expected_output(state_in, expected_state);
            display_state(expected_state, "Expected Output");
            display_state(state_out, "Actual Output");
            
            test_passed = verify_result(expected_state, state_out);
            if (test_passed)
                $display("✓ Test passed\n");
            else
                $display("✗ Test failed\n");
        end
        
        // Test completed
        $display("All tests completed!");
        $finish;
    end

endmodule