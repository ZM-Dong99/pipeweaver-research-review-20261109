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
    if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast_msb256
        wire [15:0] group_valid;
        wire [15:0] group_clear;
        wire [15:0] group_winner;
        wire [15:0] local_winner [0:15];
        wire [3:0] local_code [0:15];

        genvar g, j, b;
        for (g = 0; g < 16; g = g + 1) begin : groups
            assign group_valid[g] = |input_unencoded[g*16 +: 16];
            if (g == 15) begin : highest_group
                assign group_clear[g] = 1'b1;
            end else begin : lower_group
                assign group_clear[g] = ~(|group_valid[15:g+1]);
            end
            assign group_winner[g] = group_valid[g] & group_clear[g];

            for (j = 0; j < 16; j = j + 1) begin : positions
                if (j == 15) begin : highest_position
                    assign local_winner[g][j] = input_unencoded[g*16+j];
                end else begin : lower_position
                    assign local_winner[g][j] = input_unencoded[g*16+j]
                        & ~(|input_unencoded[g*16+15:g*16+j+1]);
                end
                if (g == 0 && j == 0) begin : default_position
                    // The original decoder selects bit zero even on an empty input.
                    assign output_unencoded[g*16+j] = ~(|input_unencoded[255:1]);
                end else begin : normal_position
                    assign output_unencoded[g*16+j] = group_clear[g] & local_winner[g][j];
                end
            end

            for (b = 0; b < 4; b = b + 1) begin : local_encoding
                wire [15:0] terms;
                for (j = 0; j < 16; j = j + 1) begin : positions
                    if ((j & (1 << b)) != 0) begin : included
                        assign terms[j] = local_winner[g][j];
                    end else begin : excluded
                        assign terms[j] = 1'b0;
                    end
                end
                assign local_code[g][b] = |terms;
            end
        end

        for (b = 0; b < 4; b = b + 1) begin : global_encoding
            wire [15:0] low_terms;
            wire [15:0] high_terms;
            for (g = 0; g < 16; g = g + 1) begin : groups
                assign low_terms[g] = group_clear[g] & local_code[g][b];
                if ((g & (1 << b)) != 0) begin : included
                    assign high_terms[g] = group_winner[g];
                end else begin : excluded
                    assign high_terms[g] = 1'b0;
                end
            end
            assign output_encoded[b] = |low_terms;
            assign output_encoded[b+4] = |high_terms;
        end
        assign output_valid = |group_valid;
    end else begin : original_parameter_behavior
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
