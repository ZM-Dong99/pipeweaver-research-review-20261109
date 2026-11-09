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
        wire [15:0] group_hot;
        wire [15:0] local_hot [0:15];
        wire [3:0] local_code [0:15];
        wire [15:0] masked_code [0:3];
        wire [3:0] high_code;
        wire [3:0] low_code;
        genvar g, k, b;

        for (g = 0; g < 16; g = g + 1) begin : groups
            wire [15:0] x;
            assign x = input_unencoded[g*16 +: 16];
            assign group_valid[g] = |x;

            // A local empty group has code zero and local one-hot bit zero.
            // Only the selected group is propagated to the outputs.
            for (k = 0; k < 16; k = k + 1) begin : local_priority
                if (k == 0) begin : bottom
                    assign local_hot[g][k] = ~(|x[15:1]);
                end else if (k == 15) begin : top
                    assign local_hot[g][k] = x[k];
                end else begin : middle
                    assign local_hot[g][k] = x[k] & ~(|x[15:k+1]);
                end
            end

            assign local_code[g][0] = |{local_hot[g][15], local_hot[g][13], local_hot[g][11], local_hot[g][9], local_hot[g][7], local_hot[g][5], local_hot[g][3], local_hot[g][1]};
            assign local_code[g][1] = |{local_hot[g][15:14], local_hot[g][11:10], local_hot[g][7:6], local_hot[g][3:2]};
            assign local_code[g][2] = |{local_hot[g][15:12], local_hot[g][7:4]};
            assign local_code[g][3] = |local_hot[g][15:8];

            if (g == 0) begin : bottom_group
                assign group_hot[g] = ~(|group_valid[15:1]);
            end else if (g == 15) begin : top_group
                assign group_hot[g] = group_valid[g];
            end else begin : middle_group
                assign group_hot[g] = group_valid[g] & ~(|group_valid[15:g+1]);
            end

            assign output_unencoded[g*16 +: 16] = local_hot[g] & {16{group_hot[g]}};
            for (b = 0; b < 4; b = b + 1) begin : code_mask
                assign masked_code[b][g] = group_hot[g] & local_code[g][b];
            end
        end

        assign high_code[0] = |{group_hot[15], group_hot[13], group_hot[11], group_hot[9], group_hot[7], group_hot[5], group_hot[3], group_hot[1]};
        assign high_code[1] = |{group_hot[15:14], group_hot[11:10], group_hot[7:6], group_hot[3:2]};
        assign high_code[2] = |{group_hot[15:12], group_hot[7:4]};
        assign high_code[3] = |group_hot[15:8];
        for (b = 0; b < 4; b = b + 1) begin : code_reduce
            assign low_code[b] = |masked_code[b];
        end
        assign output_valid = |group_valid;
        assign output_encoded = {high_code, low_code};
    end else begin : original_generic
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
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2] ? {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} : {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : msb
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2+1] ? {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]} : {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]};
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
