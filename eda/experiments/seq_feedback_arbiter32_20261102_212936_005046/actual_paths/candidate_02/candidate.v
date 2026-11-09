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

reg [PORTS-1:0] grant_reg = 0, grant_next;
reg grant_valid_reg = 0, grant_valid_next;
reg [$clog2(PORTS)-1:0] grant_encoded_reg = 0, grant_encoded_next;
reg [PORTS-1:0] mask_reg = 0, mask_next;

assign grant = grant_reg;
assign grant_valid = grant_valid_reg;
assign grant_encoded = grant_encoded_reg;

wire [PORTS-1:0] masked_request;
wire [PORTS-1:0] request_winner;
wire [PORTS-1:0] masked_winner;
wire [PORTS-1:0] selected_winner;
wire [PORTS-1:0] selected_mask;
wire [$clog2(PORTS)-1:0] selected_index;
wire request_valid;
wire masked_request_valid;
wire hold_grant;

assign masked_request = request & mask_reg;
assign request_valid = |request;
assign masked_request_valid = |masked_request;
assign hold_grant = ARB_BLOCK &&
    (ARB_BLOCK_ACK ? (grant_valid_reg && !(|(grant_reg & acknowledge))) :
                     (|(grant_reg & request)));

// Compute one-hot winners directly, without encoding and then decoding.
generate
    genvar p, b, k;
    for (p = 0; p < PORTS; p = p + 1) begin : winner_bits
        if (ARB_LSB_HIGH_PRIORITY) begin : lsb_first
            if (p == 0) begin : first_bit
                assign request_winner[p] = request[p];
                assign masked_winner[p] = masked_request[p];
                assign selected_mask[p] = 1'b0;
            end else begin : other_bits
                assign request_winner[p] = request[p] & ~(|request[p-1:0]);
                assign masked_winner[p] = masked_request[p] & ~(|masked_request[p-1:0]);
                assign selected_mask[p] = |selected_winner[p-1:0];
            end
        end else begin : msb_first
            if (p == PORTS-1) begin : first_bit
                assign request_winner[p] = request[p];
                assign masked_winner[p] = masked_request[p];
                assign selected_mask[p] = 1'b0;
            end else begin : other_bits
                assign request_winner[p] = request[p] & ~(|request[PORTS-1:p+1]);
                assign masked_winner[p] = masked_request[p] & ~(|masked_request[PORTS-1:p+1]);
                assign selected_mask[p] = |selected_winner[PORTS-1:p+1];
            end
        end
    end

    if (ARB_TYPE_ROUND_ROBIN) begin : round_robin_select
        assign selected_winner = masked_winner |
            (request_winner & {PORTS{!masked_request_valid}});
    end else begin : fixed_priority_select
        assign selected_winner = request_winner;
    end

    // The index is an OR encoding of the internally generated one-hot winner.
    for (b = 0; b < $clog2(PORTS); b = b + 1) begin : encode_bits
        wire [PORTS-1:0] terms;
        for (k = 0; k < PORTS; k = k + 1) begin : encode_terms
            if ((k >> b) & 1) begin : included
                assign terms[k] = selected_winner[k];
            end else begin : excluded
                assign terms[k] = 1'b0;
            end
        end
        assign selected_index[b] = |terms;
    end
endgenerate

always @* begin
    grant_next = selected_winner;
    grant_valid_next = request_valid;
    grant_encoded_next = selected_index;
    mask_next = mask_reg;

    if (hold_grant) begin
        grant_next = grant_reg;
        grant_valid_next = grant_valid_reg;
        grant_encoded_next = grant_encoded_reg;
    end else if (ARB_TYPE_ROUND_ROBIN && request_valid) begin
        mask_next = selected_mask;
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
