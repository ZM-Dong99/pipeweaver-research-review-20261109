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

`resetall
`timescale 1ns / 1ps
`default_nettype none

module arbiter #
(
    parameter PORTS = 4,
    parameter ARB_TYPE_ROUND_ROBIN = 0,
    parameter ARB_BLOCK = 0,
    parameter ARB_BLOCK_ACK = 1,
    parameter ARB_LSB_HIGH_PRIORITY = 0
)
(
    input  wire                     clk,
    input  wire                     rst,
    input  wire [PORTS-1:0]         request,
    input  wire [PORTS-1:0]         acknowledge,
    output wire [PORTS-1:0]         grant,
    output wire                     grant_valid,
    output wire [$clog2(PORTS)-1:0] grant_encoded
);

reg [PORTS-1:0] grant_reg = 0, grant_next;
reg grant_valid_reg = 0, grant_valid_next;
reg [$clog2(PORTS)-1:0] grant_encoded_reg = 0, grant_encoded_next;
reg [PORTS-1:0] mask_reg = 0, mask_next;

assign grant = grant_reg;
assign grant_valid = grant_valid_reg;
assign grant_encoded = grant_encoded_reg;

wire request_valid;
wire [$clog2(PORTS)-1:0] request_index;
wire masked_request_valid;
wire [$clog2(PORTS)-1:0] masked_request_index;
wire [PORTS-1:0] masked_request;

assign masked_request = request & mask_reg;

// Retain the frozen encoders for the binary index and valid outputs.
// Their binary-to-one-hot outputs are deliberately unused.
priority_encoder #(
    .WIDTH(PORTS),
    .LSB_HIGH_PRIORITY(ARB_LSB_HIGH_PRIORITY)
)
priority_encoder_inst (
    .input_unencoded(request),
    .output_valid(request_valid),
    .output_encoded(request_index),
    .output_unencoded()
);

priority_encoder #(
    .WIDTH(PORTS),
    .LSB_HIGH_PRIORITY(ARB_LSB_HIGH_PRIORITY)
)
priority_encoder_masked (
    .input_unencoded(masked_request),
    .output_valid(masked_request_valid),
    .output_encoded(masked_request_index),
    .output_unencoded()
);

// Inclusive priority-direction OR prefixes.  Constant shifts form a
// logarithmic-depth network, not a variable shifter.
localparam PREFIX_LEVELS = $clog2(PORTS);
wire [PORTS-1:0] request_prefix [PREFIX_LEVELS:0];
wire [PORTS-1:0] masked_prefix [PREFIX_LEVELS:0];

assign request_prefix[0] = request;
assign masked_prefix[0] = masked_request;

generate
    genvar level;
    for (level = 0; level < PREFIX_LEVELS; level = level + 1) begin : prefix_levels
        if (ARB_LSB_HIGH_PRIORITY) begin : lsb_first
            assign request_prefix[level+1] = request_prefix[level]
                | (request_prefix[level] << (2**level));
            assign masked_prefix[level+1] = masked_prefix[level]
                | (masked_prefix[level] << (2**level));
        end else begin : msb_first
            assign request_prefix[level+1] = request_prefix[level]
                | (request_prefix[level] >> (2**level));
            assign masked_prefix[level+1] = masked_prefix[level]
                | (masked_prefix[level] >> (2**level));
        end
    end
endgenerate

wire [PORTS-1:0] request_follow_mask;
wire [PORTS-1:0] masked_follow_mask;
wire [PORTS-1:0] request_onehot;
wire [PORTS-1:0] masked_onehot;

generate
    if (ARB_LSB_HIGH_PRIORITY) begin : lsb_masks
        assign request_follow_mask = request_prefix[PREFIX_LEVELS] << 1;
        assign masked_follow_mask = masked_prefix[PREFIX_LEVELS] << 1;
    end else begin : msb_masks
        assign request_follow_mask = request_prefix[PREFIX_LEVELS] >> 1;
        assign masked_follow_mask = masked_prefix[PREFIX_LEVELS] >> 1;
    end
endgenerate

// A bit wins exactly when it requests and no higher-priority bit requests.
// The strict prefix also equals the next round-robin eligibility mask.
assign request_onehot = request & ~request_follow_mask;
assign masked_onehot = masked_request & ~masked_follow_mask;

wire use_masked;
wire [PORTS-1:0] selected_grant;
wire [$clog2(PORTS)-1:0] selected_index;
wire [PORTS-1:0] selected_follow_mask;

assign use_masked = ARB_TYPE_ROUND_ROBIN && masked_request_valid;
assign selected_grant = use_masked ? masked_onehot : request_onehot;
assign selected_index = use_masked ? masked_request_index : request_index;
assign selected_follow_mask = use_masked ? masked_follow_mask : request_follow_mask;

always @* begin
    grant_next = 0;
    grant_valid_next = 0;
    grant_encoded_next = 0;
    mask_next = mask_reg;

    if (ARB_BLOCK && !ARB_BLOCK_ACK && (grant_reg & request)) begin
        grant_valid_next = grant_valid_reg;
        grant_next = grant_reg;
        grant_encoded_next = grant_encoded_reg;
    end else if (ARB_BLOCK && ARB_BLOCK_ACK && grant_valid && !(grant_reg & acknowledge)) begin
        grant_valid_next = grant_valid_reg;
        grant_next = grant_reg;
        grant_encoded_next = grant_encoded_reg;
    end else if (request_valid) begin
        grant_valid_next = 1;
        grant_next = selected_grant;
        grant_encoded_next = selected_index;
        if (ARB_TYPE_ROUND_ROBIN) begin
            mask_next = selected_follow_mask;
        end
    end
end

always @(posedge clk) begin
    grant_reg <= grant_next;
    grant_valid_reg <= grant_valid_next;
    grant_encoded_reg <= grant_encoded_next;
    mask_reg <= mask_next;

    if (rst) begin
        grant_reg <= 0;
        grant_valid_reg <= 0;
        grant_encoded_reg <= 0;
        mask_reg <= 0;
    end
end

endmodule

`resetall
