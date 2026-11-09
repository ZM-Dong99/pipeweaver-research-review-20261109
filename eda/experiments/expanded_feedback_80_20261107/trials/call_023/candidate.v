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
    wire [15:0] group_select;
    wire [15:0] local_select [0:15];
    wire [3:0] local_code [0:15];
    wire [15:0] low_terms [0:3];
    wire [15:0] high_terms [0:3];

    genvar g, j, b;
    for (g = 0; g < 16; g = g + 1) begin : groups
        wire [15:0] x;
        assign x = input_unencoded[16*g +: 16];
        assign group_valid[g] = |x;

        if (g == 0) begin : default_group
            assign group_select[g] = ~(|group_valid[15:1]);
        end else if (g == 15) begin : highest_group
            assign group_select[g] = group_valid[g];
        end else begin : middle_group
            assign group_select[g] = group_valid[g] & ~(|group_valid[15:g+1]);
        end

        for (j = 0; j < 16; j = j + 1) begin : local_priority
            if (j == 0) begin : default_bit
                assign local_select[g][j] = ~(|x[15:1]);
            end else if (j == 15) begin : highest_bit
                assign local_select[g][j] = x[j];
            end else begin : middle_bit
                assign local_select[g][j] = x[j] & ~(|x[15:j+1]);
            end
            assign output_unencoded[16*g+j] = group_select[g] & local_select[g][j];
        end

        assign local_code[g][0] = |(local_select[g] & 16'haaaa);
        assign local_code[g][1] = |(local_select[g] & 16'hcccc);
        assign local_code[g][2] = |(local_select[g] & 16'hf0f0);
        assign local_code[g][3] = |(local_select[g] & 16'hff00);

        for (b = 0; b < 4; b = b + 1) begin : encode_terms
            assign low_terms[b][g] = group_select[g] & local_code[g][b];
            if ((g & (1 << b)) != 0) begin : set_index_bit
                assign high_terms[b][g] = group_select[g];
            end else begin : clear_index_bit
                assign high_terms[b][g] = 1'b0;
            end
        end
    end

    for (b = 0; b < 4; b = b + 1) begin : encode_outputs
        assign output_encoded[b] = |low_terms[b];
        assign output_encoded[b+4] = |high_terms[b];
    end
    assign output_valid = |group_valid;
end else begin : generic_encoder
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
