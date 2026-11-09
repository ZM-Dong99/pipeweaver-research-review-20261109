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
    input  wire [WIDTH-1:0] input_unencoded,
    output wire output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0] output_unencoded
);

parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1;
parameter W = 2**LEVELS;

generate
    if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0) begin : fast_256
        wire [15:0] group_valid;
        wire [15:0] no_higher_group;
        wire [15:0] group_selected;
        wire [15:0] local_selected [0:15];
        wire [15:0] low_terms [0:3];

        genvar g, b, k;
        for (g = 0; g < 16; g = g + 1) begin : groups
            assign group_valid[g] = |input_unencoded[g*16 +: 16];
            if (g == 15) begin : highest_group
                assign no_higher_group[g] = 1'b1;
            end else begin : other_group
                assign no_higher_group[g] = ~|group_valid[15:g+1];
            end
            assign group_selected[g] = group_valid[g] & no_higher_group[g];

            for (b = 0; b < 16; b = b + 1) begin : bits_in_group
                if (b == 15) begin : highest_bit
                    assign local_selected[g][b] = input_unencoded[g*16+b];
                end else begin : other_bit
                    assign local_selected[g][b] = input_unencoded[g*16+b]
                        & ~|input_unencoded[g*16+15:g*16+b+1];
                end

                if (g == 0 && b == 0) begin : zero_index
                    // The original decoder selects index zero even on empty input.
                    assign output_unencoded[0] = no_higher_group[0]
                        & ~|input_unencoded[15:1];
                end else begin : nonzero_index
                    assign output_unencoded[g*16+b] = no_higher_group[g]
                        & local_selected[g][b];
                end
            end

            for (k = 0; k < 4; k = k + 1) begin : local_encoding
                // Empty groups contribute zero without a group-valid gate.
                if (k == 0) begin : bit0
                    assign low_terms[k][g] = no_higher_group[g]
                        & (|(local_selected[g] & 16'haaaa));
                end else if (k == 1) begin : bit1
                    assign low_terms[k][g] = no_higher_group[g]
                        & (|(local_selected[g] & 16'hcccc));
                end else if (k == 2) begin : bit2
                    assign low_terms[k][g] = no_higher_group[g]
                        & (|(local_selected[g] & 16'hf0f0));
                end else begin : bit3
                    assign low_terms[k][g] = no_higher_group[g]
                        & (|(local_selected[g] & 16'hff00));
                end
            end
        end

        for (k = 0; k < 4; k = k + 1) begin : low_encoding
            assign output_encoded[k] = |low_terms[k];
        end
        assign output_encoded[4] = |(group_selected & 16'haaaa);
        assign output_encoded[5] = |(group_selected & 16'hcccc);
        assign output_encoded[6] = |(group_selected & 16'hf0f0);
        assign output_encoded[7] = |(group_selected & 16'hff00);
        assign output_valid = |group_valid;
    end else begin : original_parameter_fallback
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

`resetall
