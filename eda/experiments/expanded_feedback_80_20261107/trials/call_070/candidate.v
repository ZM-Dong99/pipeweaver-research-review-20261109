`resetall
`timescale 1ns / 1ps
`default_nettype none

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
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

module priority_encoder #(
    parameter WIDTH = 4,
    parameter LSB_HIGH_PRIORITY = 0
)(
    input wire [WIDTH-1:0] input_unencoded,
    output wire output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0] output_unencoded
);

parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1;
parameter W = 2**LEVELS;

generate
if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast_msb256
    wire [15:0] group_valid;
    wire [15:0] group_suffix [0:4];
    wire [15:0] group_select;
    wire [3:0] local_code [0:15];
    wire [15:0] low_terms [0:3];

    genvar g, s, i, b;
    for (g = 0; g < 16; g = g + 1) begin : groups
        wire [15:0] suffix [0:4];
        wire [15:0] local_hot;
        assign suffix[0] = input_unencoded[g*16 +: 16];

        // Inclusive suffix OR, with a balanced four-stage topology.
        for (s = 0; s < 4; s = s + 1) begin : suffix_levels
            for (i = 0; i < 16; i = i + 1) begin : suffix_bits
                if ((i % (2**(s+1))) < (2**s)) begin : lower_half
                    assign suffix[s+1][i] = suffix[s][i] |
                        suffix[s][(i/(2**(s+1)))*(2**(s+1)) + 2**s];
                end else begin : upper_half
                    assign suffix[s+1][i] = suffix[s][i];
                end
            end
        end

        assign group_valid[g] = suffix[4][0];
        // A local empty group encodes zero. Only group zero may be
        // selected when the complete input is empty.
        assign local_hot[0] = ~suffix[4][1];
        for (i = 1; i < 15; i = i + 1) begin : local_middle
            assign local_hot[i] = input_unencoded[g*16+i] & ~suffix[4][i+1];
        end
        assign local_hot[15] = input_unencoded[g*16+15];

        assign local_code[g][0] = |(local_hot & 16'haaaa);
        assign local_code[g][1] = |(local_hot & 16'hcccc);
        assign local_code[g][2] = |(local_hot & 16'hf0f0);
        assign local_code[g][3] = |(local_hot & 16'hff00);
        assign output_unencoded[g*16 +: 16] = local_hot & {16{group_select[g]}};

        for (b = 0; b < 4; b = b + 1) begin : code_terms
            assign low_terms[b][g] = local_code[g][b] & group_select[g];
        end
    end

    assign group_suffix[0] = group_valid;
    for (s = 0; s < 4; s = s + 1) begin : group_suffix_levels
        for (i = 0; i < 16; i = i + 1) begin : group_suffix_bits
            if ((i % (2**(s+1))) < (2**s)) begin : lower_half
                assign group_suffix[s+1][i] = group_suffix[s][i] |
                    group_suffix[s][(i/(2**(s+1)))*(2**(s+1)) + 2**s];
            end else begin : upper_half
                assign group_suffix[s+1][i] = group_suffix[s][i];
            end
        end
    end

    assign output_valid = group_suffix[4][0];
    assign group_select[0] = ~group_suffix[4][1];
    for (g = 1; g < 15; g = g + 1) begin : select_middle
        assign group_select[g] = group_valid[g] & ~group_suffix[4][g+1];
    end
    assign group_select[15] = group_valid[15];

    for (b = 0; b < 4; b = b + 1) begin : low_encoding
        assign output_encoded[b] = |low_terms[b];
    end
    assign output_encoded[4] = |(group_select & 16'haaaa);
    assign output_encoded[5] = |(group_select & 16'hcccc);
    assign output_encoded[6] = |(group_select & 16'hf0f0);
    assign output_encoded[7] = |(group_select & 16'hff00);
end else begin : original_parameter_behavior
    wire [W-1:0] input_padded;
    wire [W/2-1:0] stage_valid [LEVELS-1:0];
    wire [W/2-1:0] stage_enc [LEVELS-1:0];
    assign input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    genvar l, n;
    for (n = 0; n < W/2; n = n + 1) begin : input_pairs
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin : lsb
            assign stage_enc[0][n] = !input_padded[n*2];
        end else begin : msb
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end
    for (l = 1; l < LEVELS; l = l + 1) begin : levels
        for (n = 0; n < W/(2*2**l); n = n + 1) begin : nodes
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

`resetall
