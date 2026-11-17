`timescale 1ns / 1ps
`default_nettype none

module pw_crc32_d4 (
    input  wire [3:0]  data_in,
    input  wire [31:0] state_in,
    output wire [3:0]  data_out,
    output wire [31:0] state_out
);
    // Reflected CRC32 polynomial, shifted for each of the four steps.
    localparam [31:0] P0 = 32'h1db71064;
    localparam [31:0] P1 = 32'h3b6e20c8;
    localparam [31:0] P2 = 32'h76dc4190;
    localparam [31:0] P3 = 32'hedb88320;

    // The reflected polynomial has no taps in bits 0 through 3.
    // Consequently these four feedback bits are independent.
    wire [3:0] f;
    assign f = data_in ^ state_in[3:0];
    assign data_out = f;

    // Shared, balanced parities of the feedback nibble.
    wire [15:0] parity;
    assign parity[0]  = 1'b0;
    assign parity[1]  = f[0];
    assign parity[2]  = f[1];
    assign parity[3]  = f[0] ^ f[1];
    assign parity[4]  = f[2];
    assign parity[5]  = f[0] ^ f[2];
    assign parity[6]  = f[1] ^ f[2];
    assign parity[7]  = parity[3] ^ f[2];
    assign parity[8]  = f[3];
    assign parity[9]  = f[0] ^ f[3];
    assign parity[10] = f[1] ^ f[3];
    assign parity[11] = parity[3] ^ f[3];
    assign parity[12] = f[2] ^ f[3];
    assign parity[13] = f[0] ^ parity[12];
    assign parity[14] = f[1] ^ parity[12];
    assign parity[15] = parity[3] ^ parity[12];

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : output_bits
            localparam [3:0] MASK = {P3[n], P2[n], P1[n], P0[n]};
            if (n < 28) begin : shifted_state
                assign state_out[n] = state_in[n+4] ^ parity[MASK];
            end else begin : feedback_only
                assign state_out[n] = parity[MASK];
            end
        end
    endgenerate
endmodule

`default_nettype wire
