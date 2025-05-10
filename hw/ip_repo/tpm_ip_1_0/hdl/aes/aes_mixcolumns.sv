module aes_mixcolumns(
    input  logic [7:0] state_in[4][4],
    output logic [7:0] state_out[4][4]
);


    // Based on this software implementation:
    //void mixColumns(array< array<uint8_t, 4>, 4> &state)
    // {
    //   //Create temp variable to store intermediate results                                                                            
    //   array< array<uint8_t,4>, 4> temp;
    //   //Perform matrix multiplication under GF
    //   for(int i=0;i<4;i++)
    //     {
    //       // WARNING: 3*state[0][i] is not multiplying in GF(2^8),
    //       // Replace with proper multiplication
    //       temp[0][i] = (0x02 * state[0][i]) ^ (0x03 * state[1][i]) ^ state[2][i] ^ state[3][i];
    //       temp[1][i] = state[0][i] ^ (0x02 * state[1][i]) ^ (0x03 * state[2][i]) ^ state[3][i];
    //       temp[2][i] = state[0][i] ^ state[1][i] ^ (0x02 * state[2][i]) ^ (0x03 * state[3][i]);
    //       temp[3][i] = (0x03 * state[0][i]) ^ state[1][i] ^ state[2][i] ^ (0x02 * state[3][i]);
    //     }
    //   //Fill state with mix column data                                                                                               
    //   for(int i=0;i<4;i++)
    //     for(int j=0;j<4;j++)
    //       state[j][i] = temp[j][i];
    // }


    function automatic logic [7:0] multiply_by_2(logic [7:0] x);
        return (x[7]) ? ((x << 1) ^ 8'h1b) : (x << 1);
    endfunction

    function automatic logic [7:0] multiply_by_3(logic [7:0] x);
        return multiply_by_2(x) ^ x;
    endfunction

    for (genvar i = 0; i < 4; i++) begin : mix_column
        assign state_out[0][i] = multiply_by_2(state_in[0][i]) ^ multiply_by_3(state_in[1][i]) ^ 
                                state_in[2][i] ^ state_in[3][i];
                                
        assign state_out[1][i] = state_in[0][i] ^ multiply_by_2(state_in[1][i]) ^ 
                                multiply_by_3(state_in[2][i]) ^ state_in[3][i];
                                
        assign state_out[2][i] = state_in[0][c] ^ state_in[1][i] ^ 
                                multiply_by_2(state_in[2][i]) ^ multiply_by_3(state_in[3][i]);
                                
        assign state_out[3][i] = multiply_by_3(state_in[0][i]) ^ state_in[1][i] ^ 
                                state_in[2][i] ^ multiply_by_2(state_in[3][i]);
    end

endmodule