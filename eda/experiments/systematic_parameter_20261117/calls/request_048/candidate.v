`timescale 1ns / 1ps
`default_nettype none

module pw_crc32_d4 (
    input  wire [3:0]  data_in,
    input  wire [31:0] state_in,
    output wire [3:0]  data_out,
    output wire [31:0] state_out
);
    localparam [31:0] POLY = 32'hedb88320;
    localparam [31:0] C0 = POLY >> 3;
    localparam [31:0] C1 = POLY >> 2;
    localparam [31:0] C2 = POLY >> 1;
    localparam [31:0] C3 = POLY;

    wire [3:0] feedback;
    wire [31:0] shifted_state;

    assign feedback = state_in[3:0] ^ data_in;
    assign data_out = feedback;
    assign shifted_state = {4'b0000, state_in[31:4]};

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : output_bit
            localparam [3:0] MASK = {C3[n], C2[n], C1[n], C0[n]};

            // Balance three feedback terms against the independently
            // arriving shifted-state term rather than appending it.
            if (MASK == 4'b0111) begin : triple_012
                assign state_out[n] = (feedback[0] ^ feedback[1]) ^
                                      (feedback[2] ^ shifted_state[n]);
            end else if (MASK == 4'b1011) begin : triple_013
                assign state_out[n] = (feedback[0] ^ feedback[1]) ^
                                      (feedback[3] ^ shifted_state[n]);
            end else if (MASK == 4'b1101) begin : triple_023
                assign state_out[n] = (feedback[0] ^ feedback[2]) ^
                                      (feedback[3] ^ shifted_state[n]);
            end else if (MASK == 4'b1110) begin : triple_123
                assign state_out[n] = (feedback[1] ^ feedback[2]) ^
                                      (feedback[3] ^ shifted_state[n]);
            end else begin : other_terms
                assign state_out[n] = shifted_state[n] ^
                                      (^(feedback & MASK));
            end
        end
    endgenerate
endmodule

`default_nettype wire
