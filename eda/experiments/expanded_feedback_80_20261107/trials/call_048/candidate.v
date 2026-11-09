`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * Copyright (c) 2014-2021 Alex Forencich
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
    if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast_256
        wire [15:0] group_valid;
        wire [15:0] group_selected;
        wire [255:0] local_winner;
        wire [255:0] winner;
        wire [15:0] low_terms [3:0];
        wire [3:0] high_code;
        wire [3:0] low_code;

        genvar g, j, b, k;
        for (g = 0; g < 16; g = g + 1) begin : groups
            wire [15:0] d;
            wire no_higher_group;
            assign d = input_unencoded[g*16 +: 16];
            assign group_valid[g] = |d;
            if (g == 15) begin : top_group
                assign no_higher_group = 1'b1;
            end else begin : other_group
                assign no_higher_group = ~(|group_valid[15:g+1]);
            end
            assign group_selected[g] = group_valid[g] & no_higher_group;

            for (j = 0; j < 16; j = j + 1) begin : bits_in_group
                if (j == 15) begin : top_bit
                    assign local_winner[g*16+j] = d[j];
                end else begin : other_bit
                    assign local_winner[g*16+j] = d[j] & ~(|d[15:j+1]);
                end
                assign winner[g*16+j] = local_winner[g*16+j] & no_higher_group;
            end

            for (b = 0; b < 4; b = b + 1) begin : local_encoding
                wire [15:0] terms;
                for (k = 0; k < 16; k = k + 1) begin : local_terms
                    if ((k & (1 << b)) != 0) begin : included
                        assign terms[k] = local_winner[g*16+k];
                    end else begin : excluded
                        assign terms[k] = 1'b0;
                    end
                end
                assign low_terms[b][g] = (|terms) & group_selected[g];
            end
        end

        for (b = 0; b < 4; b = b + 1) begin : global_encoding
            wire [15:0] terms;
            for (g = 0; g < 16; g = g + 1) begin : group_terms
                if ((g & (1 << b)) != 0) begin : included
                    assign terms[g] = group_selected[g];
                end else begin : excluded
                    assign terms[g] = 1'b0;
                end
            end
            assign high_code[b] = |terms;
            assign low_code[b] = |low_terms[b];
        end

        assign output_valid = |group_valid;
        assign output_encoded = {high_code, low_code};
        assign output_unencoded[255:1] = winner[255:1];
        assign output_unencoded[0] = winner[0] | ~output_valid;
    end else begin : original_parameters
        wire [W-1:0] input_padded;
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];
        assign input_padded = {{W-WIDTH{1'b0}}, input_unencoded};

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
