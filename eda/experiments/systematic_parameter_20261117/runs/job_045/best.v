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
`resetall
`timescale 1ns / 1ps
`default_nettype none

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
if (WIDTH == 128 && LSB_HIGH_PRIORITY == 0 && LEVELS == 7 && W == 128) begin : fast128
    wire [15:0] group_valid;
    wire [15:0] group_enable;
    wire [15:0] group_winner;
    wire [127:0] local_winner;
    wire [127:0] winner;
    wire [15:0] low_code [2:0];
    wire [15:0] high_code [3:0];

    for (genvar g = 0; g < 16; g = g + 1) begin : groups
        assign group_valid[g] = |input_unencoded[g*8 +: 8];
        if (g == 15) begin : last_group
            assign group_enable[g] = 1'b1;
        end else begin : other_group
            assign group_enable[g] = ~(|group_valid[15:g+1]);
        end
        assign group_winner[g] = group_valid[g] & group_enable[g];

        for (genvar j = 0; j < 8; j = j + 1) begin : bits_in_group
            if (j == 7) begin : top_bit
                assign local_winner[g*8+j] = input_unencoded[g*8+j];
            end else begin : lower_bit
                assign local_winner[g*8+j] = input_unencoded[g*8+j] &
                    ~(|input_unencoded[g*8+7:g*8+j+1]);
            end
            assign winner[g*8+j] = local_winner[g*8+j] & group_enable[g];
        end

        assign low_code[0][g] = group_enable[g] &
            (local_winner[g*8+1] | local_winner[g*8+3] |
             local_winner[g*8+5] | local_winner[g*8+7]);
        assign low_code[1][g] = group_enable[g] &
            (local_winner[g*8+2] | local_winner[g*8+3] |
             local_winner[g*8+6] | local_winner[g*8+7]);
        assign low_code[2][g] = group_enable[g] &
            (local_winner[g*8+4] | local_winner[g*8+5] |
             local_winner[g*8+6] | local_winner[g*8+7]);
        for (genvar b = 0; b < 4; b = b + 1) begin : upper_encoding
            if ((g & (1 << b)) != 0) begin : included
                assign high_code[b][g] = group_winner[g];
            end else begin : excluded
                assign high_code[b][g] = 1'b0;
            end
        end
    end
    assign output_valid = |group_valid;
    for (genvar b = 0; b < 3; b = b + 1) begin : low_outputs
        assign output_encoded[b] = |low_code[b];
    end
    for (genvar b = 0; b < 4; b = b + 1) begin : high_outputs
        assign output_encoded[b+3] = |high_code[b];
    end
    assign output_unencoded = {winner[127:1], (winner[0] | ~output_valid)};
end else begin : general_case
    wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W/2-1:0] stage_valid [LEVELS-1:0];
    wire [W/2-1:0] stage_enc [LEVELS-1:0];
    for (genvar n = 0; n < W/2; n = n + 1) begin : loop_in
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin : lsb
            assign stage_enc[0][n] = !input_padded[n*2];
        end else begin : msb
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end
    for (genvar l = 1; l < LEVELS; l = l + 1) begin : loop_levels
        for (genvar n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
            assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : lsb
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                    stage_valid[l-1][n*2] ?
                    {1'b0, stage_enc[l-1][(n*2+1)*l-1:n*2*l]} :
                    {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
            end else begin : msb
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                    stage_valid[l-1][n*2+1] ?
                    {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]} :
                    {1'b0, stage_enc[l-1][(n*2+1)*l-1:n*2*l]};
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
