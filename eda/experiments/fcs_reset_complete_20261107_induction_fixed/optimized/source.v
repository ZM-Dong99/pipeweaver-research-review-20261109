/*

Copyright (c) 2015-2018 Alex Forencich

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
 * AXI4-Stream Ethernet FCS Generator
 */
module axis_eth_fcs_reset #
(
    // Width of AXI stream interfaces in bits
    parameter DATA_WIDTH = 8,
    // Propagate tkeep signal
    // If disabled, tkeep assumed to be 1'b1
    parameter KEEP_ENABLE = (DATA_WIDTH>8),
    // tkeep signal width (words per cycle)
    parameter KEEP_WIDTH = (DATA_WIDTH/8)
)
(
    input  wire                   clk,
    input  wire                   rst,
    
    /*
     * AXI input
     */
    input  wire [DATA_WIDTH-1:0]  s_axis_tdata,
    input  wire [KEEP_WIDTH-1:0]  s_axis_tkeep,
    input  wire                   s_axis_tvalid,
    output wire                   s_axis_tready,
    input  wire                   s_axis_tlast,
    input  wire                   s_axis_tuser,
    
    /*
     * FCS output
     */
    output wire [31:0]            output_fcs,
    output wire                   output_fcs_valid
);

// bus width assertions
initial begin
    if (KEEP_WIDTH * 8 != DATA_WIDTH) begin
        $error("Error: AXI stream interface requires byte (8-bit) granularity (instance %m)");
        $finish;
    end
end

reg [31:0] crc_state;
reg [31:0] fcs_reg;
reg fcs_valid_reg;

wire [31:0] crc_next[KEEP_WIDTH-1:0];

assign s_axis_tready = 1;
assign output_fcs = fcs_reg;
assign output_fcs_valid = fcs_valid_reg;

generate

    genvar n;

    for (n = 0; n < KEEP_WIDTH; n = n + 1) begin : crc

        crc32_d8 eth_crc_inst (
            .data_in(s_axis_tdata[DATA_WIDTH/KEEP_WIDTH*(n+1)-1:0]),
            .state_in(crc_state),
            .data_out(),
            .state_out(crc_next[n])
        );

    end

endgenerate

integer i;

always @(posedge clk) begin
    fcs_valid_reg <= 1'b0;

    if (s_axis_tvalid) begin
        crc_state <= crc_next[KEEP_WIDTH-1];

        if (s_axis_tlast) begin
            crc_state <= 32'hFFFFFFFF;
            if (KEEP_ENABLE) begin
                fcs_reg <= ~crc_next[0];
                for (i = 0; i < KEEP_WIDTH; i = i + 1) begin
                    if (s_axis_tkeep[i]) begin
                        fcs_reg <= ~crc_next[i];
                    end
                end
            end else begin
                fcs_reg <= ~crc_next[KEEP_WIDTH-1];
            end
            fcs_valid_reg <= 1'b1;
        end
    end

    if (rst) begin
        crc_state <= 32'hFFFFFFFF;
        fcs_reg <= 32'h00000000;
        fcs_valid_reg <= 1'b0;
    end
end

endmodule

`resetall

module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Factor the eight input/state pairs before the parallel CRC network.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant elaboration-time symbolic simulation of eight reflected steps.
    // Each symbolic bit describes a linear combination of q[7:0].
    function [7:0] crc_mask;
        input integer index;
        reg [7:0] s [0:31];
        reg [7:0] f [0:7];
        reg [7:0] feedback;
        reg [31:0] polynomial;
        integer i, j;
        begin
            polynomial = 32'hedb88320;
            for (j = 0; j < 32; j = j + 1)
                s[j] = 8'b0;
            for (i = 0; i < 8; i = i + 1) begin
                feedback = s[0] ^ (8'b00000001 << i);
                f[i] = feedback;
                for (j = 0; j < 31; j = j + 1)
                    s[j] = s[j+1];
                s[31] = 8'b0;
                for (j = 0; j < 32; j = j + 1)
                    if (polynomial[j])
                        s[j] = s[j] ^ feedback;
            end
            if (index < 32)
                crc_mask = s[index];
            else
                crc_mask = f[index-32];
        end
    endfunction

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : state_bits
            localparam [7:0] MASK = crc_mask(n);
            if (n < 24) begin : with_shifted_state
                crc32_d8_mask_xor #(.MASK(MASK), .HAS_TAIL(1)) network (
                    .q(q), .tail(state_in[n+8]), .y(state_out[n])
                );
            end else begin : without_shifted_state
                crc32_d8_mask_xor #(.MASK(MASK), .HAS_TAIL(0)) network (
                    .q(q), .tail(1'b0), .y(state_out[n])
                );
            end
        end
        for (n = 0; n < 8; n = n + 1) begin : data_bits
            localparam [7:0] MASK = crc_mask(32+n);
            crc32_d8_mask_xor #(.MASK(MASK), .HAS_TAIL(0)) network (
                .q(q), .tail(1'b0), .y(data_out[n])
            );
        end
    endgenerate
endmodule

module crc32_d8_mask_xor #(
    parameter [7:0] MASK = 8'b0,
    parameter integer HAS_TAIL = 0
) (
    input  wire [7:0] q,
    input  wire tail,
    output wire y
);
    function integer popcount;
        input [7:0] value;
        integer k;
        begin
            popcount = 0;
            for (k = 0; k < 8; k = k + 1)
                popcount = popcount + value[k];
        end
    endfunction

    localparam integer COUNT = popcount(MASK);
    localparam integer TOTAL = COUNT + HAS_TAIL;
    localparam integer WIDTH = (TOTAL > 0) ? TOTAL : 1;
    wire [WIDTH-1:0] terms;

    genvar k;
    generate
        for (k = 0; k < 8; k = k + 1) begin : selected_terms
            if (MASK[k]) begin : selected
                localparam integer POSITION = popcount(MASK & ((8'b1 << k)-8'b1));
                assign terms[POSITION] = q[k];
            end
        end
        if (HAS_TAIL != 0) begin : tail_term
            assign terms[COUNT] = tail;
        end
        if (TOTAL == 0) begin : empty_terms
            assign terms[0] = 1'b0;
        end
    endgenerate

    crc32_d8_balanced_xor #(.WIDTH(WIDTH)) tree (.a(terms), .y(y));
endmodule

module crc32_d8_balanced_xor #(
    parameter integer WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    output wire y
);
    generate
        if (WIDTH == 1) begin : leaf
            assign y = a[0];
        end else begin : branch
            localparam integer LEFT = WIDTH / 2;
            localparam integer RIGHT = WIDTH - LEFT;
            wire lo, hi;
            crc32_d8_balanced_xor #(.WIDTH(LEFT)) left_tree (
                .a(a[LEFT-1:0]), .y(lo)
            );
            crc32_d8_balanced_xor #(.WIDTH(RIGHT)) right_tree (
                .a(a[WIDTH-1:LEFT]), .y(hi)
            );
            assign y = lo ^ hi;
        end
    endgenerate
endmodule
