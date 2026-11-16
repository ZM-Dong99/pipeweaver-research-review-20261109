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

    wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W-1:0] winner;
    wire [LEVELS-1:0] encoded;
    genvar i, b;
    generate
        for (i = 0; i < W; i = i + 1) begin : g_winner
            if (LSB_HIGH_PRIORITY) begin : g_low
                if (i == 0) begin : g_edge
                    assign winner[i] = input_padded[i];
                end else begin : g_inner
                    assign winner[i] = input_padded[i] & ~(|input_padded[i-1:0]);
                end
            end else begin : g_high
                if (i == W-1) begin : g_edge
                    assign winner[i] = input_padded[i];
                end else begin : g_inner
                    assign winner[i] = input_padded[i] & ~(|input_padded[W-1:i+1]);
                end
            end
        end
        for (b = 0; b < LEVELS; b = b + 1) begin : g_encode
            wire [W-1:0] terms;
            for (i = 0; i < W; i = i + 1) begin : g_term
                if ((i >> b) & 1) begin : g_one
                    assign terms[i] = winner[i];
                end else begin : g_zero
                    assign terms[i] = 1'b0;
                end
            end
            assign encoded[b] = (|terms) | (LSB_HIGH_PRIORITY && !output_valid);
        end
    endgenerate
    assign output_valid = |input_padded;
    assign output_encoded = encoded;
    // The reference encoder returns an encoded default even on empty input.
    // Retain its shift/truncation behavior, including WIDTH=1.
    wire [WIDTH-1:0] empty_unencoded = 1 << (LSB_HIGH_PRIORITY ? W-1 : 0);
    assign output_unencoded = output_valid ? winner[WIDTH-1:0] : empty_unencoded;
endmodule

module arbiter #(
    parameter PORTS = 4,
    parameter ARB_TYPE_ROUND_ROBIN = 0,
    parameter ARB_BLOCK = 0,
    parameter ARB_BLOCK_ACK = 1,
    parameter ARB_LSB_HIGH_PRIORITY = 0
)(
    input wire clk,
    input wire rst,
    input wire [PORTS-1:0] request,
    input wire [PORTS-1:0] acknowledge,
    output wire [PORTS-1:0] grant,
    output wire grant_valid,
    output wire [$clog2(PORTS)-1:0] grant_encoded
);
    reg [PORTS-1:0] grant_reg, grant_next;
    reg grant_valid_reg, grant_valid_next;
    reg [$clog2(PORTS)-1:0] grant_encoded_reg, grant_encoded_next;
    reg [PORTS-1:0] mask_reg, mask_next;

    assign grant = grant_reg;
    assign grant_valid = grant_valid_reg;
    assign grant_encoded = grant_encoded_reg;

    wire request_valid;
    wire [$clog2(PORTS)-1:0] request_index;
    wire [PORTS-1:0] request_mask;
    wire masked_request_valid;
    wire [$clog2(PORTS)-1:0] masked_request_index;
    wire [PORTS-1:0] masked_request_mask;
    wire [PORTS-1:0] masked_request = request & mask_reg;

    priority_encoder #(
        .WIDTH(PORTS),
        .LSB_HIGH_PRIORITY(ARB_LSB_HIGH_PRIORITY)
    ) priority_encoder_inst (
        .input_unencoded(request),
        .output_valid(request_valid),
        .output_encoded(request_index),
        .output_unencoded(request_mask)
    );

    priority_encoder #(
        .WIDTH(PORTS),
        .LSB_HIGH_PRIORITY(ARB_LSB_HIGH_PRIORITY)
    ) priority_encoder_masked (
        .input_unencoded(masked_request),
        .output_valid(masked_request_valid),
        .output_encoded(masked_request_index),
        .output_unencoded(masked_request_mask)
    );

    // Form the next thermometer mask directly from the request prefixes.
    // For MSB priority, bit j is set iff some request above j is set.
    // For LSB priority, bit j is set iff some request below j is set.
    wire [PORTS-1:0] request_next_mask;
    wire [PORTS-1:0] masked_request_next_mask;
    genvar j;
    generate
        for (j = 0; j < PORTS; j = j + 1) begin : g_next_mask
            if (ARB_LSB_HIGH_PRIORITY) begin : g_low
                if (j == 0) begin : g_edge
                    assign request_next_mask[j] = 1'b0;
                    assign masked_request_next_mask[j] = 1'b0;
                end else begin : g_inner
                    assign request_next_mask[j] = |request[j-1:0];
                    assign masked_request_next_mask[j] = |masked_request[j-1:0];
                end
            end else begin : g_high
                if (j == PORTS-1) begin : g_edge
                    assign request_next_mask[j] = 1'b0;
                    assign masked_request_next_mask[j] = 1'b0;
                end else begin : g_inner
                    assign request_next_mask[j] = |request[PORTS-1:j+1];
                    assign masked_request_next_mask[j] = |masked_request[PORTS-1:j+1];
                end
            end
        end
    endgenerate

    always @* begin
        grant_next = 0;
        grant_valid_next = 0;
        grant_encoded_next = 0;
        mask_next = mask_reg;

        if (ARB_BLOCK && !ARB_BLOCK_ACK && (|(grant_reg & request))) begin
            grant_valid_next = grant_valid_reg;
            grant_next = grant_reg;
            grant_encoded_next = grant_encoded_reg;
        end else if (ARB_BLOCK && ARB_BLOCK_ACK && grant_valid && !(|(grant_reg & acknowledge))) begin
            grant_valid_next = grant_valid_reg;
            grant_next = grant_reg;
            grant_encoded_next = grant_encoded_reg;
        end else if (request_valid) begin
            grant_valid_next = 1'b1;
            if (ARB_TYPE_ROUND_ROBIN) begin
                if (masked_request_valid) begin
                    grant_next = masked_request_mask;
                    grant_encoded_next = masked_request_index;
                    mask_next = masked_request_next_mask;
                end else begin
                    grant_next = request_mask;
                    grant_encoded_next = request_index;
                    mask_next = request_next_mask;
                end
            end else begin
                grant_next = request_mask;
                grant_encoded_next = request_index;
            end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            grant_reg <= 0;
            grant_valid_reg <= 0;
            grant_encoded_reg <= 0;
            mask_reg <= 0;
        end else begin
            grant_reg <= grant_next;
            grant_valid_reg <= grant_valid_next;
            grant_encoded_reg <= grant_encoded_next;
            mask_reg <= mask_next;
        end
    end
endmodule

`resetall
