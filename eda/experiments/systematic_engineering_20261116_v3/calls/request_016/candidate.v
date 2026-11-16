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
    parameter LSB_HIGH_PRIORITY = 0,
    parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1,
    parameter W = 2**LEVELS
)(
    input wire [WIDTH-1:0] input_unencoded,
    output wire output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0] output_unencoded
);
    wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W/2-1:0] stage_valid[LEVELS-1:0];
    wire [W/2-1:0] stage_enc[LEVELS-1:0];
    genvar l, n;
    generate
        for (n = 0; n < W/2; n = n+1) begin : loop_in
            assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin
                assign stage_enc[0][n] = !input_padded[n*2];
            end else begin
                assign stage_enc[0][n] = input_padded[n*2+1];
            end
        end
        for (l = 1; l < LEVELS; l = l+1) begin : loop_levels
            for (n = 0; n < W/(2*2**l); n = n+1) begin : loop_compress
                assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                        stage_valid[l-1][n*2] ?
                        {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                        {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                        stage_valid[l-1][n*2+1] ?
                        {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]} :
                        {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]};
                end
            end
        end
    endgenerate
    assign output_valid = stage_valid[LEVELS-1];
    assign output_encoded = stage_enc[LEVELS-1];
    assign output_unencoded = 1 << output_encoded;
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
    wire [PORTS-1:0] request_follow;
    wire [PORTS-1:0] masked_request_follow;
    wire [PORTS-1:0] request_winner;
    wire [PORTS-1:0] masked_request_winner;

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

    genvar i;
    generate
        for (i = 0; i < PORTS; i = i+1) begin : direct_priority
            if (ARB_LSB_HIGH_PRIORITY) begin : low_first
                if (i == 0) begin : edge_bit
                    assign request_follow[i] = 1'b0;
                    assign masked_request_follow[i] = 1'b0;
                end else begin : inner_bit
                    assign request_follow[i] = |request[i-1:0];
                    assign masked_request_follow[i] = |masked_request[i-1:0];
                end
            end else begin : high_first
                if (i == PORTS-1) begin : edge_bit
                    assign request_follow[i] = 1'b0;
                    assign masked_request_follow[i] = 1'b0;
                end else begin : inner_bit
                    assign request_follow[i] = |request[PORTS-1:i+1];
                    assign masked_request_follow[i] = |masked_request[PORTS-1:i+1];
                end
            end
            assign request_winner[i] = request[i] & ~request_follow[i];
            assign masked_request_winner[i] = masked_request[i] & ~masked_request_follow[i];
        end
    endgenerate

    wire [PORTS-1:0] rr_winner = masked_request_winner |
        (request_winner & {PORTS{!masked_request_valid}});
    wire [PORTS-1:0] rr_follow = masked_request_follow |
        (request_follow & {PORTS{!masked_request_valid}});

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
                grant_next = rr_winner;
                grant_encoded_next = masked_request_valid ? masked_request_index : request_index;
                mask_next = rr_follow;
            end else begin
                grant_next = request_winner;
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
