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
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
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
if (WIDTH == 128 && LSB_HIGH_PRIORITY == 0 && LEVELS == 7 && W == 128) begin : fast_msb128
    wire [15:0] group_valid;
    wire [15:0] group_enable;
    wire [15:0] group_winner;
    wire [15:0] encoded_terms [6:0];
    genvar g, j, k;

    for (g = 0; g < 16; g = g + 1) begin : groups
        wire [7:0] x;
        wire [7:0] local_winner;
        wire [2:0] local_code;
        assign x = input_unencoded[g*8 +: 8];
        assign group_valid[g] = |x;
        if (g == 15) begin : top_group
            assign group_enable[g] = 1'b1;
        end else begin : other_group
            assign group_enable[g] = ~(|group_valid[15:g+1]);
        end
        assign group_winner[g] = group_valid[g] & group_enable[g];

        for (j = 0; j < 8; j = j + 1) begin : bits_in_group
            if (j == 7) begin : highest
                assign local_winner[j] = x[j];
            end else begin : lower
                assign local_winner[j] = x[j] & ~(|x[7:j+1]);
            end
            if (g == 0 && j == 0) begin : zero_default
                assign output_unencoded[g*8+j] = group_enable[g] & ~(|x[7:1]);
            end else begin : ordinary_output
                assign output_unencoded[g*8+j] = group_enable[g] & local_winner[j];
            end
        end

        assign local_code[2] = |x[7:4];
        assign local_code[1] = (|x[7:6]) | ((~(|x[7:4])) & (|x[3:2]));
        assign local_code[0] = local_winner[7] | local_winner[5] |
                               local_winner[3] | local_winner[1];

        for (k = 0; k < 3; k = k + 1) begin : low_code
            assign encoded_terms[k][g] = group_enable[g] & local_code[k];
        end
        for (k = 3; k < 7; k = k + 1) begin : high_code
            if ((g & (1 << (k-3))) != 0) begin : contributes
                assign encoded_terms[k][g] = group_winner[g];
            end else begin : no_contribution
                assign encoded_terms[k][g] = 1'b0;
            end
        end
    end

    for (k = 0; k < 7; k = k + 1) begin : encoded_outputs
        assign output_encoded[k] = |encoded_terms[k];
    end
    assign output_valid = |group_valid;
end else begin : reference_parameters
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

`default_nettype wire
