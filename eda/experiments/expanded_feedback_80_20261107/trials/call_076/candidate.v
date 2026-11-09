/*
Copyright (c) 2014-2021 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

`resetall
`timescale 1ns / 1ps
`default_nettype none

module priority_encoder #(
    parameter WIDTH = 4,
    parameter LSB_HIGH_PRIORITY = 0
)(
    input  wire [WIDTH-1:0]         input_unencoded,
    output wire                     output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0]         output_unencoded
);

parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1;
parameter W = 2**LEVELS;

generate
    if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast_256
        wire [15:0] group_valid;
        wire [15:0] group_allow;
        wire [3:0] group_code;
        wire [15:0] low_terms [3:0];

        priority_encoder_msb16_parallel group_encoder (
            .data(group_valid),
            .valid(output_valid),
            .allow(group_allow),
            .encoded(group_code)
        );

        genvar g, j, b;
        for (g = 0; g < 16; g = g + 1) begin : groups
            wire [15:0] local_allow;
            wire [3:0] local_code;

            priority_encoder_msb16_parallel local_encoder (
                .data(input_unencoded[g*16 +: 16]),
                .valid(group_valid[g]),
                .allow(local_allow),
                .encoded(local_code)
            );

            for (b = 0; b < 4; b = b + 1) begin : code_terms
                assign low_terms[b][g] = group_allow[g] & local_code[b];
            end

            for (j = 0; j < 16; j = j + 1) begin : winners
                if (g*16+j != 0) begin : nonzero_bit
                    assign output_unencoded[g*16+j] =
                        input_unencoded[g*16+j] & local_allow[j] & group_allow[g];
                end
            end
        end

        assign output_encoded[7:4] = group_code;
        for (b = 0; b < 4; b = b + 1) begin : low_code
            assign output_encoded[b] = |low_terms[b];
        end

        // The original decoder selects bit zero even when the input is zero.
        assign output_unencoded[0] = ~(|input_unencoded[255:1]);

    end else begin : original_general
        wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];

        genvar l, n;
        for (n = 0; n < W/2; n = n + 1) begin : loop_in
            assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : lsb
                assign stage_enc[0][n] = !input_padded[n*2];
            end else begin : msb
                assign stage_enc[0][n] = input_padded[n*2+1];
            end
        end

        for (l = 1; l < LEVELS; l = l + 1) begin : loop_levels
            for (n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
                assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin : lsb
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                        stage_valid[l-1][n*2] ?
                        {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                        {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : msb
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                        stage_valid[l-1][n*2+1] ?
                        {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]} :
                        {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]};
                end
            end
        end

        assign output_valid = stage_valid[LEVELS-1];
        assign output_encoded = stage_enc[LEVELS-1];
        assign output_unencoded = 1 << output_encoded;
    end
endgenerate

endmodule

// allow[k] is true exactly when all data bits above k are zero.
// encoded is the highest asserted index, or zero for an empty input.
module priority_encoder_msb16_parallel (
    input  wire [15:0] data,
    output wire        valid,
    output wire [15:0] allow,
    output wire [3:0]  encoded
);
    wire [3:0] nibble_valid;
    wire [3:0] nibble_allow;
    wire [3:0] bit1_terms;
    wire [3:0] bit0_terms;

    assign nibble_allow[3] = 1'b1;
    assign nibble_allow[2] = ~nibble_valid[3];
    assign nibble_allow[1] = ~(|nibble_valid[3:2]);
    assign nibble_allow[0] = ~(|nibble_valid[3:1]);

    genvar n;
    generate
        for (n = 0; n < 4; n = n + 1) begin : nibbles
            assign nibble_valid[n] = |data[n*4 +: 4];

            assign allow[n*4+3] = nibble_allow[n];
            assign allow[n*4+2] = nibble_allow[n] & ~data[n*4+3];
            assign allow[n*4+1] = nibble_allow[n] & ~(|data[n*4+3:n*4+2]);
            assign allow[n*4]   = nibble_allow[n] & ~(|data[n*4+3:n*4+1]);

            assign bit1_terms[n] = nibble_allow[n] &
                (data[n*4+3] | data[n*4+2]);
            assign bit0_terms[n] = nibble_allow[n] &
                (data[n*4+3] | (~data[n*4+2] & data[n*4+1]));
        end
    endgenerate

    assign valid = |nibble_valid;
    assign encoded[3] = nibble_valid[3] | nibble_valid[2];
    assign encoded[2] = nibble_valid[3] | (nibble_valid[1] & ~nibble_valid[2]);
    assign encoded[1] = |bit1_terms;
    assign encoded[0] = |bit0_terms;
endmodule

`resetall
