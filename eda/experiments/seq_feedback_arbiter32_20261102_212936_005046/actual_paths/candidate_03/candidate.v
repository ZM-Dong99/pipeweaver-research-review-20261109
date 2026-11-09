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

wire [PORTS-1:0] masked_request = request & mask_reg;
wire request_valid = |request;
wire masked_request_valid = |masked_request;
wire use_masked = ARB_TYPE_ROUND_ROBIN && masked_request_valid;
wire [PORTS-1:0] plain_winner;
wire [PORTS-1:0] masked_winner;
wire [PORTS-1:0] plain_next_mask;
wire [PORTS-1:0] masked_next_mask;
wire [PORTS-1:0] selected_winner = use_masked ? masked_winner : plain_winner;
wire [PORTS-1:0] selected_mask = use_masked ? masked_next_mask : plain_next_mask;
wire [$clog2(PORTS)-1:0] selected_index;

genvar i, b;
generate
    for (i = 0; i < PORTS; i = i + 1) begin : priority_bits
        if (ARB_LSB_HIGH_PRIORITY) begin : lsb_priority
            if (i == 0) begin : first_bit
                assign plain_winner[i] = request[i];
                assign masked_winner[i] = masked_request[i];
                assign plain_next_mask[i] = 1'b0;
                assign masked_next_mask[i] = 1'b0;
            end else begin : other_bits
                assign plain_winner[i] = request[i] & ~(|request[i-1:0]);
                assign masked_winner[i] = masked_request[i] & ~(|masked_request[i-1:0]);
                assign plain_next_mask[i] = |request[i-1:0];
                assign masked_next_mask[i] = |masked_request[i-1:0];
            end
        end else begin : msb_priority
            if (i == PORTS-1) begin : first_bit
                assign plain_winner[i] = request[i];
                assign masked_winner[i] = masked_request[i];
                assign plain_next_mask[i] = 1'b0;
                assign masked_next_mask[i] = 1'b0;
            end else begin : other_bits
                assign plain_winner[i] = request[i] & ~(|request[PORTS-1:i+1]);
                assign masked_winner[i] = masked_request[i] & ~(|masked_request[PORTS-1:i+1]);
                assign plain_next_mask[i] = |request[PORTS-1:i+1];
                assign masked_next_mask[i] = |masked_request[PORTS-1:i+1];
            end
        end
    end
    for (b = 0; b < $clog2(PORTS); b = b + 1) begin : encode_bits
        wire [PORTS-1:0] terms;
        for (i = 0; i < PORTS; i = i + 1) begin : encode_terms
            if ((i >> b) & 1) begin : included
                assign terms[i] = selected_winner[i];
            end else begin : excluded
                assign terms[i] = 1'b0;
            end
        end
        assign selected_index[b] = |terms;
    end
endgenerate

always @* begin
    grant_next = 0;
    grant_valid_next = 0;
    grant_encoded_next = 0;
    mask_next = mask_reg;

    if (ARB_BLOCK && !ARB_BLOCK_ACK && (|(grant_reg & request))) begin
        grant_next = grant_reg;
        grant_valid_next = grant_valid_reg;
        grant_encoded_next = grant_encoded_reg;
    end else if (ARB_BLOCK && ARB_BLOCK_ACK && grant_valid_reg && !(|(grant_reg & acknowledge))) begin
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
