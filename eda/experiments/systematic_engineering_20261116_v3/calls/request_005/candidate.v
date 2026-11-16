`resetall
`timescale 1ns / 1ps
`default_nettype none

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

wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
wire [W/2-1:0] stage_valid [LEVELS-1:0];
wire [W/2-1:0] stage_enc [LEVELS-1:0];

generate
    genvar l, n, i;
    for (n = 0; n < W/2; n = n+1) begin : loop_in
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin : low
            assign stage_enc[0][n] = !input_padded[n*2];
        end else begin : high
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end
    for (l = 1; l < LEVELS; l = l+1) begin : loop_levels
        for (n = 0; n < W/(2*2**l); n = n+1) begin : loop_compress
            assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : low
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                    stage_valid[l-1][n*2] ?
                    {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                    {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
            end else begin : high
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                    stage_valid[l-1][n*2+1] ?
                    {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]} :
                    {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]};
            end
        end
    end

    // Generate the one-hot result directly, without binary decode.
    // Preserve the encoder's defined result even for an empty input.
    if (W == 2**LEVELS && LEVELS == (WIDTH > 2 ? $clog2(WIDTH) : 1)) begin : direct_onehot
        for (i = 0; i < WIDTH; i = i+1) begin : bit_result
            wire winner;
            if (LSB_HIGH_PRIORITY) begin : low
                if (i == 0) begin : edge_bit
                    assign winner = input_unencoded[i];
                end else begin : interior_bit
                    assign winner = input_unencoded[i] & ~(|input_unencoded[i-1:0]);
                end
                if (i == W-1) begin : empty_result
                    assign output_unencoded[i] = winner | ~output_valid;
                end else begin : ordinary_result
                    assign output_unencoded[i] = winner;
                end
            end else begin : high
                if (i == WIDTH-1) begin : edge_bit
                    assign winner = input_unencoded[i];
                end else begin : interior_bit
                    assign winner = input_unencoded[i] & ~(|input_unencoded[WIDTH-1:i+1]);
                end
                if (i == 0) begin : empty_result
                    assign output_unencoded[i] = winner | ~output_valid;
                end else begin : ordinary_result
                    assign output_unencoded[i] = winner;
                end
            end
        end
    end else begin : parameter_fallback
        assign output_unencoded = 1 << output_encoded;
    end
endgenerate

assign output_valid = stage_valid[LEVELS-1];
assign output_encoded = stage_enc[LEVELS-1];
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

wire [PORTS-1:0] request_successor_mask;
wire [PORTS-1:0] masked_successor_mask;

generate
    genvar k;
    for (k = 0; k < PORTS; k = k+1) begin : successor_masks
        if (ARB_LSB_HIGH_PRIORITY) begin : low
            if (k == 0) begin : edge_bit
                assign request_successor_mask[k] = 1'b0;
                assign masked_successor_mask[k] = 1'b0;
            end else begin : interior_bit
                assign request_successor_mask[k] = |request[k-1:0];
                assign masked_successor_mask[k] = |masked_request[k-1:0];
            end
        end else begin : high
            if (k == PORTS-1) begin : edge_bit
                assign request_successor_mask[k] = 1'b0;
                assign masked_successor_mask[k] = 1'b0;
            end else begin : interior_bit
                assign request_successor_mask[k] = |request[PORTS-1:k+1];
                assign masked_successor_mask[k] = |masked_request[PORTS-1:k+1];
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
        grant_valid_next = grant_valid_reg;
        grant_next = grant_reg;
        grant_encoded_next = grant_encoded_reg;
    end else if (ARB_BLOCK && ARB_BLOCK_ACK && grant_valid && !(grant_reg & acknowledge)) begin
        grant_valid_next = grant_valid_reg;
        grant_next = grant_reg;
        grant_encoded_next = grant_encoded_reg;
    end else if (request_valid) begin
        grant_valid_next = 1'b1;
        if (ARB_TYPE_ROUND_ROBIN) begin
            if (masked_request_valid) begin
                grant_next = masked_request_mask;
                grant_encoded_next = masked_request_index;
                mask_next = masked_successor_mask;
            end else begin
                grant_next = request_mask;
                grant_encoded_next = request_index;
                mask_next = request_successor_mask;
            end
        end else begin
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
