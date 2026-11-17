module pw_crc32_d4 (
    input wire [3:0] data_in,
    input wire [31:0] state_in,
    output wire [3:0] data_out,
    output wire [31:0] state_out
);
    // Independent feedback bits for the four reflected CRC steps.
    wire [3:0] f;
    wire p01, p12, p23;
    assign f = data_in ^ state_in[3:0];
    assign data_out = f;
    assign p01 = f[0] ^ f[1];
    assign p12 = f[1] ^ f[2];
    assign p23 = f[2] ^ f[3];

    assign state_out[0]  = state_in[4];
    assign state_out[1]  = state_in[5];
    assign state_out[2]  = state_in[6] ^ f[0];
    assign state_out[3]  = state_in[7] ^ f[1];
    assign state_out[4]  = state_in[8] ^ f[2];
    assign state_out[5]  = state_in[9] ^ f[3];
    assign state_out[6]  = state_in[10] ^ p01;
    assign state_out[7]  = state_in[11] ^ p12;
    assign state_out[8]  = state_in[12] ^ p23;
    assign state_out[9]  = state_in[13] ^ f[3];
    assign state_out[10] = state_in[14];
    assign state_out[11] = state_in[15];
    assign state_out[12] = state_in[16] ^ f[0];
    assign state_out[13] = state_in[17] ^ f[1];
    assign state_out[14] = state_in[18] ^ f[2];
    assign state_out[15] = state_in[19] ^ f[3];
    assign state_out[16] = state_in[20] ^ f[0];
    assign state_out[17] = state_in[21] ^ p01;
    assign state_out[18] = (state_in[22] ^ f[2]) ^ p01;
    assign state_out[19] = (state_in[23] ^ f[1]) ^ p23;
    assign state_out[20] = (state_in[24] ^ f[0]) ^ p23;
    assign state_out[21] = (state_in[25] ^ f[3]) ^ p01;
    assign state_out[22] = state_in[26] ^ p12;
    assign state_out[23] = (state_in[27] ^ f[0]) ^ p23;
    assign state_out[24] = (state_in[28] ^ f[3]) ^ p01;
    assign state_out[25] = state_in[29] ^ p12;
    assign state_out[26] = (state_in[30] ^ f[0]) ^ p23;
    assign state_out[27] = (state_in[31] ^ f[3]) ^ p01;
    assign state_out[28] = p01 ^ f[2];
    assign state_out[29] = f[1] ^ p23;
    assign state_out[30] = p23;
    assign state_out[31] = f[3];
endmodule
