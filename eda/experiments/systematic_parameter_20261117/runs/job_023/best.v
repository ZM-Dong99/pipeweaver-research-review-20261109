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
if (WIDTH == 64 && LSB_HIGH_PRIORITY == 0 && LEVELS == 6 && W == 64) begin : fast64
    wire [7:0] group_valid;
    wire [7:0] group_select;
    wire [2:0] local_code [0:7];
    wire [7:0] code_bit0;
    wire [7:0] code_bit1;
    wire [7:0] code_bit2;

    genvar g, b;
    for (g = 0; g < 8; g = g + 1) begin : groups
        wire [7:0] x;
        wire [7:0] local_onehot;
        assign x = input_unencoded[g*8 +: 8];
        assign group_valid[g] = |x;

        if (g == 0) begin : bottom_group
            // Select group zero on an entirely empty input as well.
            assign group_select[g] = ~(|group_valid[7:1]);
        end else if (g == 7) begin : top_group
            assign group_select[g] = group_valid[g];
        end else begin : middle_group
            assign group_select[g] = group_valid[g] &
                                      ~(|group_valid[7:g+1]);
        end

        // Direct equations avoid a local encoded-bus mux cascade.
        assign local_code[g][2] = |x[7:4];
        assign local_code[g][1] = (|x[7:6]) |
                                      ((~(|x[7:4])) & (|x[3:2]));
        assign local_code[g][0] = x[7] |
                                      (x[5] & ~(|x[7:6])) |
                                      (x[3] & ~(|x[7:4])) |
                                      (x[1] & ~(|x[7:2]));

        // Local zero defaults to bit zero. Only the selected group matters.
        assign local_onehot[0] = ~(|x[7:1]);
        assign local_onehot[7] = x[7];
        for (b = 1; b < 7; b = b + 1) begin : local_bits
            assign local_onehot[b] = x[b] & ~(|x[7:b+1]);
        end
        assign output_unencoded[g*8 +: 8] =
            local_onehot & {8{group_select[g]}};

        assign code_bit0[g] = local_code[g][0] & group_select[g];
        assign code_bit1[g] = local_code[g][1] & group_select[g];
        assign code_bit2[g] = local_code[g][2] & group_select[g];
    end

    assign output_valid = |group_valid;
    assign output_encoded[2:0] = {
        |code_bit2, |code_bit1, |code_bit0
    };
    assign output_encoded[5] = |group_valid[7:4];
    assign output_encoded[4] = (|group_valid[7:6]) |
        ((~(|group_valid[7:4])) & (|group_valid[3:2]));
    assign output_encoded[3] = group_valid[7] |
        (group_valid[5] & ~(|group_valid[7:6])) |
        (group_valid[3] & ~(|group_valid[7:4])) |
        (group_valid[1] & ~(|group_valid[7:2]));
end else begin : reference_parameters
    wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W/2-1:0] stage_valid [LEVELS-1:0];
    wire [W/2-1:0] stage_enc [LEVELS-1:0];
    genvar l, n;
    for (n = 0; n < W/2; n = n + 1) begin : loop_in
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin : low_first
            assign stage_enc[0][n] = !input_padded[n*2];
        end else begin : high_first
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end
    for (l = 1; l < LEVELS; l = l + 1) begin : loop_levels
        for (n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
            assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : low_first
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                    stage_valid[l-1][n*2] ?
                    {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                    {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
            end else begin : high_first
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
