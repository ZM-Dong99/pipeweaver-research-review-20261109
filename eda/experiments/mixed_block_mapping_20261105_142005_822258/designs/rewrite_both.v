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
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire select_a;
    wire select_b, select_c, select_d, select_e;
    wire select_f, select_g, select_h, select_i, select_j;

    assign select_a = (~sel[3] & ~sel[2] & ~sel[1] & ~sel[0])
                    | (sel[3] & (sel[2] | sel[1]));
    assign select_b = (sel == 4'd1);
    assign select_c = (sel == 4'd2);
    assign select_d = (sel == 4'd3);
    assign select_e = (sel == 4'd4);
    assign select_f = (sel == 4'd5);
    assign select_g = (sel == 4'd6);
    assign select_h = (sel == 4'd7);
    assign select_i = (sel == 4'd8);
    assign select_j = (sel == 4'd9);

    always @(*) begin
        block_out = ({8{select_a}} & block_a)
                  | ({8{select_b}} & block_b)
                  | ({8{select_c}} & block_c)
                  | ({8{select_d}} & block_d)
                  | ({8{select_e}} & block_e)
                  | ({8{select_f}} & block_f)
                  | ({8{select_g}} & block_g)
                  | ({8{select_h}} & block_h)
                  | ({8{select_i}} & block_i)
                  | ({8{select_j}} & block_j);
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

generate
if (WIDTH >= 2 && LSB_HIGH_PRIORITY == 0 && LEVELS == ((WIDTH > 2) ? $clog2(WIDTH) : 1) && W == 2**LEVELS) begin : pw_grouped
    localparam integer GB = 8;
    localparam integer GROUPS = (WIDTH+GB-1)/GB;
    localparam integer PAD = GROUPS*GB;
    localparam integer LOW_BITS = $clog2(GB);
    wire [PAD-1:0] padded = {{(PAD-WIDTH){1'b0}},input_unencoded};
    wire [GROUPS-1:0] group_valid,group_enable,group_winner;
    wire [PAD-1:0] local_winner,global_winner;
    genvar pg,pj,pb,pe,pk;
    for (pg=0; pg<GROUPS; pg=pg+1) begin : groups
        assign group_valid[pg] = |padded[pg*GB +: GB];
        if (pg==GROUPS-1) begin : top
            assign group_enable[pg] = 1'b1;
        end else begin : remaining
            assign group_enable[pg] = ~(|group_valid[GROUPS-1:pg+1]);
        end
        assign group_winner[pg] = group_valid[pg] & group_enable[pg];
        for (pj=0; pj<GB; pj=pj+1) begin : bits_in_group
            if (pj==GB-1) begin : top
                assign local_winner[pg*GB+pj] = padded[pg*GB+pj];
            end else begin : remaining
                assign local_winner[pg*GB+pj] = padded[pg*GB+pj] & ~(|padded[pg*GB+GB-1:pg*GB+pj+1]);
            end
            assign global_winner[pg*GB+pj] = group_enable[pg] & local_winner[pg*GB+pj];
            if (pg*GB+pj<WIDTH) begin : real_output
                if (pg==0 && pj==0) begin : empty_input_default
                    assign output_unencoded[0] = group_enable[0] & ~(|padded[GB-1:1]);
                end else begin : ordinary
                    assign output_unencoded[pg*GB+pj] = global_winner[pg*GB+pj];
                end
            end
        end
    end
    assign output_valid = |group_valid;
    for (pb=0; pb<$clog2(WIDTH); pb=pb+1) begin : encoded_bits
        wire [GROUPS-1:0] terms;
        for (pe=0; pe<GROUPS; pe=pe+1) begin : group_terms
            if (pb<LOW_BITS) begin : local_index
                wire [GB-1:0] masked;
                for (pk=0; pk<GB; pk=pk+1) begin : mask_bits
                    assign masked[pk] = ((pk >> pb)&1) ? local_winner[pe*GB+pk] : 1'b0;
                end
                assign terms[pe] = group_enable[pe] & (|masked);
            end else begin : group_index
                assign terms[pe] = ((pe >> (pb-LOW_BITS))&1) ? group_winner[pe] : 1'b0;
            end
        end
        assign output_encoded[pb] = |terms;
    end
end else begin : pw_original
// pad input to even power of two
wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};

wire [W/2-1:0] stage_valid[LEVELS-1:0];
wire [W/2-1:0] stage_enc[LEVELS-1:0];

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

assign output_valid = stage_valid[LEVELS-1];
assign output_encoded = stage_enc[LEVELS-1];
assign output_unencoded = 1 << output_encoded;

end
endgenerate

endmodule

`resetall
