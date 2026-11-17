`timescale 1ns / 1ps
`default_nettype none
module pw_crc32_d4 (
    input  wire [3:0] data_in,
    input  wire [31:0] state_in,
    output wire [3:0] data_out,
    output wire [31:0] state_out
);
    // Reflected Ethernet CRC polynomial, advanced by four bits.
    localparam [31:0] P0 = 32'hedb88320 >> 3;
    localparam [31:0] P1 = 32'hedb88320 >> 2;
    localparam [31:0] P2 = 32'hedb88320 >> 1;
    localparam [31:0] P3 = 32'hedb88320;

    // The low four polynomial bits are zero, so all four feedback
    // bits can be computed independently from the original inputs.
    wire [3:0] feedback;
    assign feedback = data_in ^ state_in[3:0];
    assign data_out = feedback;

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : bit_result
            localparam [3:0] MASK = {P3[n], P2[n], P1[n], P0[n]};
            localparam integer COUNT =
                ((MASK >> 0) & 1) + ((MASK >> 1) & 1) +
                ((MASK >> 2) & 1) + ((MASK >> 3) & 1);
            localparam [3:0] ONE = MASK & (~MASK + 4'b0001);
            wire shifted;
            if (n < 28) begin : original_state
                assign shifted = state_in[n+4];
            end else begin : zero_fill
                assign shifted = 1'b0;
            end

            if (COUNT == 0) begin : no_feedback
                assign state_out[n] = shifted;
            end else if (COUNT == 3) begin : balanced_three
                // Balance the state term with one feedback bit instead
                // of placing it after a three-feedback parity chain.
                wire pair_parity;
                wire state_parity;
                assign pair_parity = ^(feedback & (MASK ^ ONE));
                assign state_parity = shifted ^ (^(feedback & ONE));
                assign state_out[n] = pair_parity ^ state_parity;
            end else begin : other_feedback
                assign state_out[n] = shifted ^ (^(feedback & MASK));
            end
        end
    endgenerate
endmodule
`default_nettype wire
