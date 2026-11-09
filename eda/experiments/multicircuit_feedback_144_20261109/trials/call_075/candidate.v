/*
Copyright (c) 2016-2023 Alex Forencich

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
`timescale 1ns / 1ps
`default_nettype none

module crc32_d8 (
    input  wire [7:0] data_in,
    input  wire [31:0] state_in,
    output wire [7:0] data_out,
    output wire [31:0] state_out
);
    // Factor the common state/data parity before the CRC matrix.
    wire [7:0] t;
    assign t = state_in[7:0] ^ data_in;

    // Constant evaluation only: contribution of one low-byte basis bit
    // after eight reflected Galois shifts.
    function [31:0] basis;
        input integer bit_index;
        reg [31:0] c;
        integer k;
        begin
            c = 32'h00000001 << bit_index;
            for (k = 0; k < 8; k = k + 1) begin
                if (c[0])
                    c = (c >> 1) ^ 32'hedb88320;
                else
                    c = c >> 1;
            end
            basis = c;
        end
    endfunction

    function [7:0] row_mask;
        input integer row;
        reg [31:0] column;
        integer k;
        begin
            row_mask = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                column = basis(k);
                row_mask[k] = column[row];
            end
        end
    endfunction

    function integer count_bits;
        input [7:0] mask;
        integer k;
        begin
            count_bits = 0;
            for (k = 0; k < 8; k = k + 1)
                count_bits = count_bits + mask[k];
        end
    endfunction

    function integer position;
        input [7:0] mask;
        input integer limit;
        integer k;
        begin
            position = 0;
            for (k = 0; k < limit; k = k + 1)
                position = position + mask[k];
        end
    endfunction

    genvar r, b;
    generate
        for (r = 0; r < 32; r = r + 1) begin : rows
            localparam [7:0] MASK = row_mask(r);
            localparam integer N = count_bits(MASK);
            localparam integer EXTRA = (r < 24) ? 1 : 0;
            wire [N+EXTRA-1:0] terms;
            for (b = 0; b < 8; b = b + 1) begin : columns
                if (MASK[b]) begin : selected
                    assign terms[position(MASK, b)] = t[b];
                end
            end
            if (r < 24) begin : shifted_state
                assign terms[N] = state_in[r+8];
            end
            // Compact operands let synthesis balance the parity tree
            // without zero-filled sparse reduction branches.
            assign state_out[r] = ^terms;
        end
    endgenerate

    // These are the actual feedback bits shifted out, not a data bypass.
    assign data_out[4:0] = t[4:0];
    assign data_out[5] = t[5] ^ t[0];
    assign data_out[6] = t[6] ^ t[1];
    assign data_out[7] = t[7] ^ t[2];
endmodule

`default_nettype wire
