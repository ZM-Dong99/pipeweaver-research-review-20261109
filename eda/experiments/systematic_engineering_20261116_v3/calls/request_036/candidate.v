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
localparam EW = $clog2(WIDTH) > 0 ? $clog2(WIDTH) : 2;
wire [WIDTH-1:0] winner;
wire [EW-1:0] encoded_valid;
assign output_valid = |input_unencoded;
generate
    genvar i, b;
    for (i = 0; i < WIDTH; i = i + 1) begin : priority_bits
        if (LSB_HIGH_PRIORITY) begin : low_first
            if (i == 0) begin : edge_bit
                assign winner[i] = input_unencoded[i];
            end else begin : other_bit
                assign winner[i] = input_unencoded[i] & ~(|input_unencoded[i-1:0]);
            end
        end else begin : high_first
            if (i == WIDTH-1) begin : edge_bit
                assign winner[i] = input_unencoded[i];
            end else begin : other_bit
                assign winner[i] = input_unencoded[i] & ~(|input_unencoded[WIDTH-1:i+1]);
            end
        end
    end
    for (b = 0; b < EW; b = b + 1) begin : encode_bits
        wire [WIDTH-1:0] terms;
        for (i = 0; i < WIDTH; i = i + 1) begin : encode_terms
            if ((i >> b) & 1) begin : set_bit
                assign terms[i] = winner[i];
            end else begin : clear_bit
                assign terms[i] = 1'b0;
            end
        end
        assign encoded_valid[b] = |terms;
    end
endgenerate
// Preserve the reference encoder's defined outputs even when invalid.
assign output_encoded = output_valid ? encoded_valid :
                        (LSB_HIGH_PRIORITY ? W-1 : 0);
assign output_unencoded = output_valid ? winner :
                          (LSB_HIGH_PRIORITY ? ({{WIDTH-1{1'b0}},1'b1} << (W-1)) : {{WIDTH-1{1'b0}},1'b1});
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

// The next round-robin mask is the strict prefix (or suffix) OR
// of the requests, not an encoded-index-dependent barrel shift.
wire [PORTS-1:0] request_follow_mask;
wire [PORTS-1:0] masked_follow_mask;
generate
    genvar j;
    for (j = 0; j < PORTS; j = j + 1) begin : follow_masks
        if (ARB_LSB_HIGH_PRIORITY) begin : low_first
            if (j == 0) begin : edge_bit
                assign request_follow_mask[j] = 1'b0;
                assign masked_follow_mask[j] = 1'b0;
            end else begin : other_bit
                assign request_follow_mask[j] = |request[j-1:0];
                assign masked_follow_mask[j] = |masked_request[j-1:0];
            end
        end else begin : high_first
            if (j == PORTS-1) begin : edge_bit
                assign request_follow_mask[j] = 1'b0;
                assign masked_follow_mask[j] = 1'b0;
            end else begin : other_bit
                assign request_follow_mask[j] = |request[PORTS-1:j+1];
                assign masked_follow_mask[j] = |masked_request[PORTS-1:j+1];
            end
        end
    end
endgenerate

always @* begin
    grant_next = 0;
    grant_valid_next = 0;
    grant_encoded_next = 0;
    mask_next = mask_reg;

    if (ARB_BLOCK && !ARB_BLOCK_ACK && (grant_reg & request)) begin
        grant_next = grant_reg;
        grant_valid_next = grant_valid_reg;
        grant_encoded_next = grant_encoded_reg;
    end else if (ARB_BLOCK && ARB_BLOCK_ACK && grant_valid && !(grant_reg & acknowledge)) begin
        grant_next = grant_reg;
        grant_valid_next = grant_valid_reg;
        grant_encoded_next = grant_encoded_reg;
    end else if (request_valid) begin
        grant_valid_next = 1'b1;
        if (ARB_TYPE_ROUND_ROBIN) begin
            if (masked_request_valid) begin
                grant_next = masked_request_mask;
                grant_encoded_next = masked_request_index;
                mask_next = masked_follow_mask;
            end else begin
                grant_next = request_mask;
                grant_encoded_next = request_index;
                mask_next = request_follow_mask;
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
