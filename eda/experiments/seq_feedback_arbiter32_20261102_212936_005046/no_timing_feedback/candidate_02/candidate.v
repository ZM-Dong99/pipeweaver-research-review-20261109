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

localparam INDEX_WIDTH = $clog2(PORTS);

reg [PORTS-1:0] grant_reg = 0, grant_next;
reg grant_valid_reg = 0, grant_valid_next;
reg [$clog2(PORTS)-1:0] grant_encoded_reg = 0, grant_encoded_next;
reg [PORTS-1:0] mask_reg = 0, mask_next;

assign grant = grant_reg;
assign grant_valid = grant_valid_reg;
assign grant_encoded = grant_encoded_reg;

wire [PORTS-1:0] masked_request;
assign masked_request = request & mask_reg;

wire request_valid;
wire masked_request_valid;
assign request_valid = |request;
assign masked_request_valid = |masked_request;

// Each bit reports whether a higher-priority request exists.
// These vectors are also the next round-robin masks for their winners.
wire [PORTS-1:0] request_higher;
wire [PORTS-1:0] masked_request_higher;
wire [PORTS-1:0] request_winner;
wire [PORTS-1:0] masked_request_winner;

assign request_winner = request & ~request_higher;
assign masked_request_winner = masked_request & ~masked_request_higher;

genvar p, b;
generate
    for (p = 0; p < PORTS; p = p + 1) begin : priority_bits
        if (ARB_LSB_HIGH_PRIORITY) begin : lsb_priority
            if (p == 0) begin : boundary
                assign request_higher[p] = 1'b0;
                assign masked_request_higher[p] = 1'b0;
            end else begin : interior
                assign request_higher[p] = |request[p-1:0];
                assign masked_request_higher[p] = |masked_request[p-1:0];
            end
        end else begin : msb_priority
            if (p == PORTS-1) begin : boundary
                assign request_higher[p] = 1'b0;
                assign masked_request_higher[p] = 1'b0;
            end else begin : interior
                assign request_higher[p] = |request[PORTS-1:p+1];
                assign masked_request_higher[p] = |masked_request[PORTS-1:p+1];
            end
        end
    end
endgenerate

// Encode the internally generated one-hot winners with parallel OR trees.
wire [INDEX_WIDTH-1:0] request_index;
wire [INDEX_WIDTH-1:0] masked_request_index;
wire [PORTS-1:0] request_encode_terms [INDEX_WIDTH-1:0];
wire [PORTS-1:0] masked_encode_terms [INDEX_WIDTH-1:0];

generate
    for (b = 0; b < INDEX_WIDTH; b = b + 1) begin : encode_bits
        for (p = 0; p < PORTS; p = p + 1) begin : encode_terms
            if ((p >> b) & 1) begin : included
                assign request_encode_terms[b][p] = request_winner[p];
                assign masked_encode_terms[b][p] = masked_request_winner[p];
            end else begin : excluded
                assign request_encode_terms[b][p] = 1'b0;
                assign masked_encode_terms[b][p] = 1'b0;
            end
        end
        assign request_index[b] = |request_encode_terms[b];
        assign masked_request_index[b] = |masked_encode_terms[b];
    end
endgenerate

wire use_masked;
wire [PORTS-1:0] selected_winner;
wire [INDEX_WIDTH-1:0] selected_index;
wire [PORTS-1:0] selected_mask;

assign use_masked = ARB_TYPE_ROUND_ROBIN && masked_request_valid;
assign selected_winner = use_masked ? masked_request_winner : request_winner;
assign selected_index = use_masked ? masked_request_index : request_index;
assign selected_mask = use_masked ? masked_request_higher : request_higher;

always @* begin
    grant_next = 0;
    grant_valid_next = 0;
    grant_encoded_next = 0;
    mask_next = mask_reg;

    if (ARB_BLOCK && !ARB_BLOCK_ACK && (|(grant_reg & request))) begin
        grant_next = grant_reg;
        grant_valid_next = grant_valid_reg;
        grant_encoded_next = grant_encoded_reg;
    end else if (ARB_BLOCK && ARB_BLOCK_ACK && grant_valid_reg &&
                 !(|(grant_reg & acknowledge))) begin
        grant_next = grant_reg;
        grant_valid_next = grant_valid_reg;
        grant_encoded_next = grant_encoded_reg;
    end else if (request_valid) begin
        grant_next = selected_winner;
        grant_valid_next = 1'b1;
        grant_encoded_next = selected_index;
        if (ARB_TYPE_ROUND_ROBIN) begin
            mask_next = selected_mask;
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
