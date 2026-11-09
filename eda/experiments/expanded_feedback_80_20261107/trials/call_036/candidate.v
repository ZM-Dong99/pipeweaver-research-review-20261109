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
        if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast_256
            wire [255:0] winner;
            pe_radix4_msb #(.N(256), .E(8)) tree (
                .x(input_unencoded),
                .v(output_valid),
                .c(output_encoded),
                .h(winner)
            );
            assign output_unencoded = winner | {{255{1'b0}}, ~output_valid};
        end else begin : original_behavior
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
                    if (LSB_HIGH_PRIORITY) begin : lsb_select
                        assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                            stage_valid[l-1][n*2] ?
                            {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                            {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                    end else begin : msb_select
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

// Internal helper: N is a power of four, E is log2(N).
// Both c and h are zero when x is zero.
module pe_radix4_msb #(
    parameter N = 4,
    parameter E = 2
)(
    input wire [N-1:0] x,
    output wire v,
    output wire [E-1:0] c,
    output wire [N-1:0] h
);
    generate
        if (N == 4) begin : leaf
            wire allow2;
            wire allow1;
            wire allow0;
            assign allow2 = ~x[3];
            assign allow1 = ~(|x[3:2]);
            assign allow0 = ~(|x[3:1]);
            assign v = |x;
            assign c[1] = |x[3:2];
            assign c[0] = x[3] | (x[1] & allow1);
            assign h[3] = x[3];
            assign h[2] = x[2] & allow2;
            assign h[1] = x[1] & allow1;
            assign h[0] = x[0] & allow0;
        end else begin : branch
            localparam Q = N/4;
            wire [3:0] cv;
            wire [E-3:0] c0, c1, c2, c3;
            wire [Q-1:0] h0, h1, h2, h3;
            wire allow2;
            wire allow1;
            wire allow0;

            pe_radix4_msb #(.N(Q), .E(E-2)) child0 (
                .x(x[Q-1:0]), .v(cv[0]), .c(c0), .h(h0)
            );
            pe_radix4_msb #(.N(Q), .E(E-2)) child1 (
                .x(x[2*Q-1:Q]), .v(cv[1]), .c(c1), .h(h1)
            );
            pe_radix4_msb #(.N(Q), .E(E-2)) child2 (
                .x(x[3*Q-1:2*Q]), .v(cv[2]), .c(c2), .h(h2)
            );
            pe_radix4_msb #(.N(Q), .E(E-2)) child3 (
                .x(x[4*Q-1:3*Q]), .v(cv[3]), .c(c3), .h(h3)
            );

            assign allow2 = ~cv[3];
            assign allow1 = ~(|cv[3:2]);
            assign allow0 = ~(|cv[3:1]);
            assign v = |cv;
            assign c[E-1] = |cv[3:2];
            assign c[E-2] = cv[3] | (cv[1] & allow1);
            assign c[E-3:0] = c3 |
                (c2 & {(E-2){allow2}}) |
                (c1 & {(E-2){allow1}}) |
                (c0 & {(E-2){allow0}});

            assign h[4*Q-1:3*Q] = h3;
            assign h[3*Q-1:2*Q] = h2 & {Q{allow2}};
            assign h[2*Q-1:Q] = h1 & {Q{allow1}};
            assign h[Q-1:0] = h0 & {Q{allow0}};
        end
    endgenerate
endmodule

`resetall
