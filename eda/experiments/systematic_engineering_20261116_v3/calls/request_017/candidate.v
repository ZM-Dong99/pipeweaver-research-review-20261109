/*
 * Copyright (c) 2014-2021 Alex Forencich
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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

wire [PORTS-1:0] masked_request = request & mask_reg;
wire request_valid = |request;
wire masked_request_valid = |masked_request;
wire [PORTS-1:0] request_winner;
wire [PORTS-1:0] masked_request_winner;
wire [PORTS-1:0] request_thermometer;
wire [PORTS-1:0] masked_request_thermometer;

genvar g;
generate
    for (g = 0; g < PORTS; g = g+1) begin : priority_bits
        if (ARB_LSB_HIGH_PRIORITY) begin : low_priority_first
            if (g == 0) begin : edge_bit
                assign request_winner[g] = request[g];
                assign masked_request_winner[g] = masked_request[g];
                assign request_thermometer[g] = 1'b0;
                assign masked_request_thermometer[g] = 1'b0;
            end else begin : interior_bit
                assign request_winner[g] = request[g] & ~(|request[g-1:0]);
                assign masked_request_winner[g] = masked_request[g] & ~(|masked_request[g-1:0]);
                assign request_thermometer[g] = |request[g-1:0];
                assign masked_request_thermometer[g] = |masked_request[g-1:0];
            end
        end else begin : high_priority_first
            if (g == PORTS-1) begin : edge_bit
                assign request_winner[g] = request[g];
                assign masked_request_winner[g] = masked_request[g];
                assign request_thermometer[g] = 1'b0;
                assign masked_request_thermometer[g] = 1'b0;
            end else begin : interior_bit
                assign request_winner[g] = request[g] & ~(|request[PORTS-1:g+1]);
                assign masked_request_winner[g] = masked_request[g] & ~(|masked_request[PORTS-1:g+1]);
                assign request_thermometer[g] = |request[PORTS-1:g+1];
                assign masked_request_thermometer[g] = |masked_request[PORTS-1:g+1];
            end
        end
    end
endgenerate

/* Encode by parallel OR planes, rather than a priority-multiplexer tree. */
localparam INDEX_BITS = $clog2(PORTS) > 0 ? $clog2(PORTS) : 2;
localparam ENCODER_LEVELS = PORTS > 2 ? $clog2(PORTS) : 1;
wire [$clog2(PORTS)-1:0] request_index_raw;
wire [$clog2(PORTS)-1:0] masked_request_index_raw;
genvar b, k;
generate
    for (b = 0; b < INDEX_BITS; b = b+1) begin : encode_bits
        wire [PORTS-1:0] req_terms;
        wire [PORTS-1:0] masked_terms;
        for (k = 0; k < PORTS; k = k+1) begin : terms
            if ((k >> b) & 1) begin : included
                assign req_terms[k] = request_winner[k];
                assign masked_terms[k] = masked_request_winner[k];
            end else begin : excluded
                assign req_terms[k] = 1'b0;
                assign masked_terms[k] = 1'b0;
            end
        end
        assign request_index_raw[b] = |req_terms;
        assign masked_request_index_raw[b] = |masked_terms;
    end
endgenerate

/* Preserve the reference encoder's defined invalid-input values. */
wire [$clog2(PORTS)-1:0] request_index = request_valid ? request_index_raw :
    (ARB_LSB_HIGH_PRIORITY ? (2**ENCODER_LEVELS-1) : 0);
wire [$clog2(PORTS)-1:0] masked_request_index = masked_request_valid ? masked_request_index_raw :
    (ARB_LSB_HIGH_PRIORITY ? (2**ENCODER_LEVELS-1) : 0);
wire [PORTS-1:0] request_mask = 1 << request_index;
wire [PORTS-1:0] masked_request_mask = 1 << masked_request_index;

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
        grant_valid_next = 1'b1;
        if (ARB_TYPE_ROUND_ROBIN && masked_request_valid) begin
            grant_next = masked_request_winner;
            grant_encoded_next = masked_request_index_raw;
            mask_next = masked_request_thermometer;
        end else begin
            grant_next = request_winner;
            grant_encoded_next = request_index_raw;
            if (ARB_TYPE_ROUND_ROBIN)
                mask_next = request_thermometer;
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
