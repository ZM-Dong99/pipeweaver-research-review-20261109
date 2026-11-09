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
if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast
    wire [15:0] gv;
    wire [15:0] ge;
    wire [15:0] gw;
    wire [255:0] lw;
    wire [3:0] lc [0:15];
    wire [15:0] low_term [0:3];
    wire [15:0] high_term [0:3];
    genvar g, j, b;
    for (g = 0; g < 16; g = g+1) begin : groups
        assign gv[g] = |input_unencoded[g*16 +: 16];
        if (g == 15) begin : top
            assign ge[g] = 1'b1;
        end else begin : lower
            assign ge[g] = ~(|gv[15:g+1]);
        end
        assign gw[g] = gv[g] & ge[g];
        for (j = 0; j < 16; j = j+1) begin : bits_in_group
            if (j == 15) begin : top
                assign lw[g*16+j] = input_unencoded[g*16+j];
            end else begin : lower
                assign lw[g*16+j] = input_unencoded[g*16+j] &
                    ~(|input_unencoded[g*16+15:g*16+j+1]);
            end
            if (g == 0 && j == 0) begin : default_bit
                assign output_unencoded[0] = ge[0] &
                    ~(|input_unencoded[15:1]);
            end else begin : ordinary_bit
                assign output_unencoded[g*16+j] = ge[g] & lw[g*16+j];
            end
        end
        assign lc[g][0] = |(lw[g*16 +: 16] & 16'haaaa);
        assign lc[g][1] = |(lw[g*16 +: 16] & 16'hcccc);
        assign lc[g][2] = |(lw[g*16 +: 16] & 16'hf0f0);
        assign lc[g][3] = |input_unencoded[g*16+15:g*16+8];
        for (b = 0; b < 4; b = b+1) begin : terms
            assign low_term[b][g] = ge[g] & lc[g][b];
            if ((g & (1 << b)) != 0) begin : selected
                assign high_term[b][g] = gw[g];
            end else begin : unselected
                assign high_term[b][g] = 1'b0;
            end
        end
    end
    for (b = 0; b < 4; b = b+1) begin : encode
        assign output_encoded[b] = |low_term[b];
        assign output_encoded[b+4] = |high_term[b];
    end
    assign output_valid = |gv;
end else begin : original_behavior
    wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W/2-1:0] stage_valid [LEVELS-1:0];
    wire [W/2-1:0] stage_enc [LEVELS-1:0];
    genvar l, n;
    for (n = 0; n < W/2; n = n+1) begin : loop_in
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin : low
            assign stage_enc[0][n] = !input_padded[n*2];
        end else begin : high
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end
    for (l = 1; l < LEVELS; l = l+1) begin : loop_levels
        for (n = 0; n < W/(2*2**l); n = n+1) begin : loop_compress
            assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : low
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                    stage_valid[l-1][n*2] ?
                    {1'b0, stage_enc[l-1][(n*2+1)*l-1:n*2*l]} :
                    {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
            end else begin : high
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
