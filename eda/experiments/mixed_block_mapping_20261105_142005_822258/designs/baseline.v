module mixed_datapath (
    input wire [79:0] mux_data,
    input wire [3:0] mux_sel,
    input wire [63:0] requests,
    output wire [7:0] selected_data,
    output wire request_valid,
    output wire [5:0] request_index,
    output wire [63:0] request_onehot
);
choice_block choice (.block_a(mux_data[0 +: 8]), .block_b(mux_data[8 +: 8]), .block_c(mux_data[16 +: 8]), .block_d(mux_data[24 +: 8]), .block_e(mux_data[32 +: 8]), .block_f(mux_data[40 +: 8]), .block_g(mux_data[48 +: 8]), .block_h(mux_data[56 +: 8]), .block_i(mux_data[64 +: 8]), .block_j(mux_data[72 +: 8]), .sel(mux_sel), .block_out(selected_data));
request_block #(.WIDTH(64), .LSB_HIGH_PRIORITY(0)) request_path (
    .input_unencoded(requests), .output_valid(request_valid),
    .output_encoded(request_index), .output_unencoded(request_onehot)
);
endmodule

module choice_block (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,  // 4 bit select signal
    output reg [7:0] block_out
);

    always @(*) begin
        case (sel)
            4'b0000: block_out = block_a;
            4'b0001: block_out = block_b;
            4'b0010: block_out = block_c;
            4'b0011: block_out = block_d;
            4'b0100: block_out = block_e;
            4'b0101: block_out = block_f;
            4'b0110: block_out = block_g;
            4'b0111: block_out = block_h;
            4'b1000: block_out = block_i;
            4'b1001: block_out = block_j;
            default: block_out = block_a; 
        endcase
    end
endmodule
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

// Language: Verilog 2001

`resetall
`timescale 1ns / 1ps
`default_nettype none

/*
 * Priority encoder module
 */
module request_block #
(
    parameter WIDTH = 4,
    // LSB priority selection
    parameter LSB_HIGH_PRIORITY = 0
)
(
    input  wire [WIDTH-1:0]         input_unencoded,
    output wire                     output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0]         output_unencoded
);

parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1;
parameter W = 2**LEVELS;

// pad input to even power of two
wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};

wire [W/2-1:0] stage_valid[LEVELS-1:0];
wire [W/2-1:0] stage_enc[LEVELS-1:0];

generate
    genvar l, n;

    // process input bits; generate valid bit and encoded bit for each pair
    for (n = 0; n < W/2; n = n + 1) begin : loop_in
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin
            // bit 0 is highest priority
            assign stage_enc[0][n] = !input_padded[n*2+0];
        end else begin
            // bit 0 is lowest priority
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end

    // compress down to single valid bit and encoded bus
    for (l = 1; l < LEVELS; l = l + 1) begin : loop_levels
        for (n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
            assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin
                // bit 0 is highest priority
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2+0] ? {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2+0)*l]} : {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
            end else begin
                // bit 0 is lowest priority
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2+1] ? {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]} : {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2+0)*l]};
            end
        end
    end
endgenerate

assign output_valid = stage_valid[LEVELS-1];
assign output_encoded = stage_enc[LEVELS-1];
assign output_unencoded = 1 << output_encoded;

endmodule

`resetall
