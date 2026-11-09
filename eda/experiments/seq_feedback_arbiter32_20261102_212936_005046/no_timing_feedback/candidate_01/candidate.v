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

wire [PORTS-1:0] masked_request;
assign masked_request = request & mask_reg;

wire request_valid;
wire [$clog2(PORTS)-1:0] request_index;
wire masked_request_valid;
wire [$clog2(PORTS)-1:0] masked_request_index;

// Keep the frozen encoders for the encoded outputs only.
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

wire [PORTS-1:0] request_mask;
wire [PORTS-1:0] masked_request_mask;
wire [PORTS-1:0] request_rr_mask;
wire [PORTS-1:0] masked_request_rr_mask;
wire [PORTS-1:0] request_higher;
wire [PORTS-1:0] masked_request_higher;

// A bit wins iff it is requested and no higher-priority bit is requested.
// The same higher-priority reduction directly gives each next-mask bit:
// that bit is enabled iff the winning request has higher priority.
generate
    genvar i;
    for (i = 0; i < PORTS; i = i + 1) begin : direct_priority
        if (ARB_LSB_HIGH_PRIORITY) begin : lsb_first
            if (i == 0) begin : endpoint
                assign request_higher[i] = 1'b0;
                assign masked_request_higher[i] = 1'b0;
            end else begin : interior
                assign request_higher[i] = |request[i-1:0];
                assign masked_request_higher[i] = |masked_request[i-1:0];
            end
        end else begin : msb_first
            if (i == PORTS-1) begin : endpoint
                assign request_higher[i] = 1'b0;
                assign masked_request_higher[i] = 1'b0;
            end else begin : interior
                assign request_higher[i] = |request[PORTS-1:i+1];
                assign masked_request_higher[i] = |masked_request[PORTS-1:i+1];
            end
        end
        assign request_mask[i] = request[i] & ~request_higher[i];
        assign masked_request_mask[i] = masked_request[i] & ~masked_request_higher[i];
        assign request_rr_mask[i] = request_higher[i];
        assign masked_request_rr_mask[i] = masked_request_higher[i];
    end
endgenerate

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
        if (ARB_TYPE_ROUND_ROBIN) begin
            if (masked_request_valid) begin
                grant_valid_next = 1;
                grant_next = masked_request_mask;
                grant_encoded_next = masked_request_index;
                mask_next = masked_request_rr_mask;
            end else begin
                grant_valid_next = 1;
                grant_next = request_mask;
                grant_encoded_next = request_index;
                mask_next = request_rr_mask;
            end
        end else begin
            grant_valid_next = 1;
            grant_next = request_mask;
            grant_encoded_next = request_index;
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
