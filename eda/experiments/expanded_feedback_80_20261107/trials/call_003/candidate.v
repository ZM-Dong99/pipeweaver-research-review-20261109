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
    if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast256
        wire [15:0] group_valid;
        wire [15:0] group_enable;
        wire [15:0] group_winner;
        wire [255:0] winner;
        wire [15:0] low_terms [3:0];
        wire [15:0] high_terms [3:0];
        wire [7:0] encoded;
        wire valid;
        genvar g, i, b;

        for (g = 0; g < 16; g = g + 1) begin : groups
            wire [15:0] x;
            wire [15:0] local_winner;
            wire [3:0] local_encoded;
            assign x = input_unencoded[g*16 +: 16];
            assign group_valid[g] = |x;
            if (g == 15) begin : top_group
                assign group_enable[g] = 1'b1;
            end else begin : other_group
                assign group_enable[g] = ~(|group_valid[15:g+1]);
            end
            assign group_winner[g] = group_valid[g] & group_enable[g];

            for (i = 0; i < 16; i = i + 1) begin : bits_in_group
                if (i == 15) begin : top_bit
                    assign local_winner[i] = x[i];
                end else begin : other_bit
                    assign local_winner[i] = x[i] & ~(|x[15:i+1]);
                end
                assign winner[g*16+i] = local_winner[i] & group_enable[g];
            end

            for (b = 0; b < 4; b = b + 1) begin : code_bits
                wire [15:0] terms;
                for (i = 0; i < 16; i = i + 1) begin : blocks
                    if ((i % (2**(b+1))) == 2**b) begin : used
                        if (i + 2**b == 16) begin : last_block
                            assign terms[i] = |x[i + 2**b - 1:i];
                        end else begin : middle_block
                            assign terms[i] = (|x[i + 2**b - 1:i]) &
                                              ~(|x[15:i + 2**b]);
                        end
                    end else begin : unused
                        assign terms[i] = 1'b0;
                    end
                end
                assign local_encoded[b] = |terms;
                assign low_terms[b][g] = local_encoded[b] & group_enable[g];
                if ((g & (2**b)) != 0) begin : high_one
                    assign high_terms[b][g] = group_winner[g];
                end else begin : high_zero
                    assign high_terms[b][g] = 1'b0;
                end
            end
        end

        for (b = 0; b < 4; b = b + 1) begin : final_code
            assign encoded[b] = |low_terms[b];
            assign encoded[b+4] = |high_terms[b];
        end

        assign valid = |group_valid;
        assign output_valid = valid;
        assign output_encoded = encoded;
        assign output_unencoded = {winner[255:1], (winner[0] | ~valid)};
    end else begin : original_configuration
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
