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
    parameter LSB_HIGH_PRIORITY = 0,
    parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1,
    parameter W = 2**LEVELS
)(
    input  wire [WIDTH-1:0] input_unencoded,
    output wire output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0] output_unencoded
);

generate
if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast_256
    wire [15:0] group_valid;
    wire [15:0] group_allow;
    wire [15:0] group_winner;
    wire [15:0] local_winner [0:15];
    wire [3:0] local_code [0:15];
    wire [15:0] code_terms [0:3];
    genvar g, b, k;

    for (g = 0; g < 16; g = g + 1) begin : groups
        assign group_valid[g] = |input_unencoded[g*16 +: 16];
        if (g == 15) begin : top_group
            assign group_allow[g] = 1'b1;
        end else begin : lower_group
            assign group_allow[g] = ~(|group_valid[15:g+1]);
        end
        assign group_winner[g] = group_valid[g] & group_allow[g];

        for (b = 0; b < 16; b = b + 1) begin : bits_in_group
            if (b == 15) begin : top_bit
                assign local_winner[g][b] = input_unencoded[g*16+b];
            end else begin : lower_bit
                assign local_winner[g][b] = input_unencoded[g*16+b]
                    & ~(|input_unencoded[g*16+15:g*16+b+1]);
            end
            if (g == 0 && b == 0) begin : default_bit
                // The reference shift produces bit zero even on an empty input.
                assign output_unencoded[g*16+b] = ~(|input_unencoded[255:1]);
            end else begin : selected_bit
                assign output_unencoded[g*16+b] = group_allow[g] & local_winner[g][b];
            end
        end

        assign local_code[g][0] = |(local_winner[g] & 16'haaaa);
        assign local_code[g][1] = |(local_winner[g] & 16'hcccc);
        assign local_code[g][2] = |(local_winner[g] & 16'hf0f0);
        assign local_code[g][3] = |input_unencoded[g*16+8 +: 8];
        for (k = 0; k < 4; k = k + 1) begin : code_columns
            assign code_terms[k][g] = group_allow[g] & local_code[g][k];
        end
    end

    assign output_valid = |group_valid;
    assign output_encoded[0] = |code_terms[0];
    assign output_encoded[1] = |code_terms[1];
    assign output_encoded[2] = |code_terms[2];
    assign output_encoded[3] = |code_terms[3];
    assign output_encoded[4] = |(group_winner & 16'haaaa);
    assign output_encoded[5] = |(group_winner & 16'hcccc);
    assign output_encoded[6] = |(group_winner & 16'hf0f0);
    assign output_encoded[7] = |group_valid[15:8];
end else begin : reference_parameters
    wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W/2-1:0] stage_valid [LEVELS-1:0];
    wire [W/2-1:0] stage_enc [LEVELS-1:0];
    genvar l, n;

    for (n = 0; n < W/2; n = n + 1) begin : loop_in
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin : lsb_pair
            assign stage_enc[0][n] = !input_padded[n*2];
        end else begin : msb_pair
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end

    for (l = 1; l < LEVELS; l = l + 1) begin : loop_levels
        for (n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
            assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : lsb_compress
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                    stage_valid[l-1][n*2] ?
                    {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                    {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
            end else begin : msb_compress
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
