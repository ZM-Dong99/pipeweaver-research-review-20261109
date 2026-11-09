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

module arbiter #(
    parameter PORTS = 4,
    parameter ARB_TYPE_ROUND_ROBIN = 0,
    parameter ARB_BLOCK = 0,
    parameter ARB_BLOCK_ACK = 1,
    parameter ARB_LSB_HIGH_PRIORITY = 0
)(
    input  wire                     clk,
    input  wire                     rst,
    input  wire [PORTS-1:0]         request,
    input  wire [PORTS-1:0]         acknowledge,
    output wire [PORTS-1:0]         grant,
    output wire                     grant_valid,
    output wire [$clog2(PORTS)-1:0] grant_encoded
);

reg [PORTS-1:0] grant_reg = 0;
reg grant_valid_reg = 0;
reg [$clog2(PORTS)-1:0] grant_encoded_reg = 0;
reg [PORTS-1:0] mask_reg = 0;

assign grant = grant_reg;
assign grant_valid = grant_valid_reg;
assign grant_encoded = grant_encoded_reg;

wire [PORTS-1:0] masked_request = request & mask_reg;
wire request_valid = |request;
wire masked_request_valid = |masked_request;

// Each bit indicates whether a higher-priority request exists.
// These same prefixes are the round-robin masks after selection.
wire [PORTS-1:0] request_prefix;
wire [PORTS-1:0] masked_prefix;
wire [PORTS-1:0] request_winner;
wire [PORTS-1:0] masked_winner;

genvar p, b;
generate
    for (p = 0; p < PORTS; p = p + 1) begin : priority_bits
        if (ARB_LSB_HIGH_PRIORITY) begin : lsb_first
            if (p == 0) begin : boundary
                assign request_prefix[p] = 1'b0;
                assign masked_prefix[p] = 1'b0;
            end else begin : interior
                assign request_prefix[p] = |request[p-1:0];
                assign masked_prefix[p] = |masked_request[p-1:0];
            end
        end else begin : msb_first
            if (p == PORTS-1) begin : boundary
                assign request_prefix[p] = 1'b0;
                assign masked_prefix[p] = 1'b0;
            end else begin : interior
                assign request_prefix[p] = |request[PORTS-1:p+1];
                assign masked_prefix[p] = |masked_request[PORTS-1:p+1];
            end
        end
        assign request_winner[p] = request[p] & ~request_prefix[p];
        assign masked_winner[p] = masked_request[p] & ~masked_prefix[p];
    end
endgenerate

wire hold_grant = ARB_BLOCK &&
    (ARB_BLOCK_ACK ? (grant_valid_reg && !(|(grant_reg & acknowledge))) :
                     (|(grant_reg & request)));

wire use_masked = ARB_TYPE_ROUND_ROBIN && masked_request_valid;
wire take_masked = !hold_grant && use_masked;
wire take_request = !hold_grant && !use_masked && request_valid;

wire [PORTS-1:0] selected_grant =
    ({PORTS{take_masked}} & masked_winner) |
    ({PORTS{take_request}} & request_winner);

wire [PORTS-1:0] grant_next =
    ({PORTS{hold_grant}} & grant_reg) | selected_grant;
wire grant_valid_next =
    (hold_grant && grant_valid_reg) || (!hold_grant && request_valid);

wire [$clog2(PORTS)-1:0] selected_encoded;
wire [$clog2(PORTS)-1:0] grant_encoded_next;
generate
    for (b = 0; b < $clog2(PORTS); b = b + 1) begin : encode_bits
        wire [PORTS-1:0] terms;
        for (p = 0; p < PORTS; p = p + 1) begin : encode_terms
            if ((p >> b) & 1) begin : index_one
                assign terms[p] = selected_grant[p];
            end else begin : index_zero
                assign terms[p] = 1'b0;
            end
        end
        assign selected_encoded[b] = |terms;
        assign grant_encoded_next[b] =
            (hold_grant & grant_encoded_reg[b]) | selected_encoded[b];
    end
endgenerate

wire update_mask = ARB_TYPE_ROUND_ROBIN && !hold_grant && request_valid;
wire [PORTS-1:0] mask_next =
    ({PORTS{!update_mask}} & mask_reg) |
    ({PORTS{ARB_TYPE_ROUND_ROBIN && take_masked}} & masked_prefix) |
    ({PORTS{ARB_TYPE_ROUND_ROBIN && take_request}} & request_prefix);

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
