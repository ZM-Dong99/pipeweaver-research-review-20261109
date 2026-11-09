`resetall
`timescale 1ns / 1ps
`default_nettype none

module crc_xor40 #(
    parameter [39:0] MASK = 40'b0
) (
    input wire [7:0] data_in,
    input wire [31:0] state_in,
    output wire out
);
    wire [39:0] v = {data_in, state_in} & MASK;
    wire [4:0] g;
    assign g[0] = ^v[7:0];
    assign g[1] = ^v[15:8];
    assign g[2] = ^v[23:16];
    assign g[3] = ^v[31:24];
    assign g[4] = ^v[39:32];
    assign out = ^g;
endmodule

module lfsr #(
    parameter LFSR_WIDTH = 31,
    parameter LFSR_POLY = 31'h10000001,
    parameter LFSR_CONFIG = "FIBONACCI",
    parameter LFSR_FEED_FORWARD = 0,
    parameter REVERSE = 0,
    parameter DATA_WIDTH = 8,
    parameter STYLE = "AUTO"
) (
    input wire [DATA_WIDTH-1:0] data_in,
    input wire [LFSR_WIDTH-1:0] state_in,
    output wire [DATA_WIDTH-1:0] data_out,
    output wire [LFSR_WIDTH-1:0] state_out
);
    function [LFSR_WIDTH+DATA_WIDTH-1:0] lfsr_mask(input [31:0] index);
        reg [LFSR_WIDTH-1:0] ls [LFSR_WIDTH-1:0];
        reg [DATA_WIDTH-1:0] ld [LFSR_WIDTH-1:0];
        reg [LFSR_WIDTH-1:0] os [DATA_WIDTH-1:0];
        reg [DATA_WIDTH-1:0] od [DATA_WIDTH-1:0];
        reg [LFSR_WIDTH-1:0] sv;
        reg [DATA_WIDTH-1:0] dv;
        reg [DATA_WIDTH-1:0] dm;
        integer i, j;
        begin
            for (i = 0; i < LFSR_WIDTH; i = i + 1) begin
                ls[i] = 0;
                ls[i][i] = 1'b1;
                ld[i] = 0;
            end
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                os[i] = 0;
                if (i < LFSR_WIDTH)
                    os[i][i] = 1'b1;
                od[i] = 0;
            end
            for (dm = {1'b1,{DATA_WIDTH-1{1'b0}}}; dm != 0; dm = dm >> 1) begin
                sv = ls[LFSR_WIDTH-1];
                dv = ld[LFSR_WIDTH-1] ^ dm;
                for (j = LFSR_WIDTH-1; j > 0; j = j - 1) begin
                    ls[j] = ls[j-1];
                    ld[j] = ld[j-1];
                end
                for (j = DATA_WIDTH-1; j > 0; j = j - 1) begin
                    os[j] = os[j-1];
                    od[j] = od[j-1];
                end
                os[0] = sv;
                od[0] = dv;
                if (LFSR_FEED_FORWARD) begin
                    sv = 0;
                    dv = dm;
                end
                ls[0] = sv;
                ld[0] = dv;
                for (j = 1; j < LFSR_WIDTH; j = j + 1) begin
                    if ((LFSR_POLY >> j) & 1) begin
                        ls[j] = ls[j] ^ sv;
                        ld[j] = ld[j] ^ dv;
                    end
                end
            end
            if (REVERSE) begin
                if (index < LFSR_WIDTH) begin
                    sv = 0;
                    for (i = 0; i < LFSR_WIDTH; i = i + 1)
                        sv[i] = ls[LFSR_WIDTH-index-1][LFSR_WIDTH-i-1];
                    dv = 0;
                    for (i = 0; i < DATA_WIDTH; i = i + 1)
                        dv[i] = ld[LFSR_WIDTH-index-1][DATA_WIDTH-i-1];
                end else begin
                    sv = 0;
                    for (i = 0; i < LFSR_WIDTH; i = i + 1)
                        sv[i] = os[DATA_WIDTH-(index-LFSR_WIDTH)-1][LFSR_WIDTH-i-1];
                    dv = 0;
                    for (i = 0; i < DATA_WIDTH; i = i + 1)
                        dv[i] = od[DATA_WIDTH-(index-LFSR_WIDTH)-1][DATA_WIDTH-i-1];
                end
            end else begin
                if (index < LFSR_WIDTH) begin
                    sv = ls[index];
                    dv = ld[index];
                end else begin
                    sv = os[index-LFSR_WIDTH];
                    dv = od[index-LFSR_WIDTH];
                end
            end
            lfsr_mask = {dv,sv};
        end
    endfunction

    genvar n;
    generate
        for (n = 0; n < LFSR_WIDTH; n = n + 1) begin : state_bits
            wire [39:0] mask = lfsr_mask(n);
            crc_xor40 #(.MASK(mask)) u (.data_in(data_in), .state_in(state_in), .out(state_out[n]));
        end
        for (n = 0; n < DATA_WIDTH; n = n + 1) begin : data_bits
            wire [39:0] mask = lfsr_mask(n + LFSR_WIDTH);
            crc_xor40 #(.MASK(mask)) u (.data_in(data_in), .state_in(state_in), .out(data_out[n]));
        end
    endgenerate
endmodule

module crc32_d8(input wire [7:0] data_in, input wire [31:0] state_in, output wire [7:0] data_out, output wire [31:0] state_out);
    lfsr #(.LFSR_WIDTH(32), .LFSR_POLY(32'h04c11db7), .LFSR_CONFIG("GALOIS"), .LFSR_FEED_FORWARD(0), .REVERSE(1), .DATA_WIDTH(8), .STYLE("REDUCTION")) core (.data_in(data_in), .state_in(state_in), .data_out(data_out), .state_out(state_out));
endmodule

`resetall
