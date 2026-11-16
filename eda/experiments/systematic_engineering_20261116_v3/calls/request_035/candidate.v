`resetall
`timescale 1ns / 1ps
`default_nettype none

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

localparam ENC_WIDTH = PORTS > 1 ? $clog2(PORTS) : 2;
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
wire [PORTS-1:0] request_higher;
wire [PORTS-1:0] masked_request_higher;
wire [PORTS-1:0] request_winner;
wire [PORTS-1:0] masked_request_winner;

genvar i, b;
generate
    for (i = 0; i < PORTS; i = i + 1) begin : priority_terms
        if (ARB_LSB_HIGH_PRIORITY) begin : lsb
            if (i == 0) begin : edge_bit
                assign request_higher[i] = 1'b0;
                assign masked_request_higher[i] = 1'b0;
            end else begin : other_bits
                assign request_higher[i] = |request[i-1:0];
                assign masked_request_higher[i] = |masked_request[i-1:0];
            end
        end else begin : msb
            if (i == PORTS-1) begin : edge_bit
                assign request_higher[i] = 1'b0;
                assign masked_request_higher[i] = 1'b0;
            end else begin : other_bits
                assign request_higher[i] = |request[PORTS-1:i+1];
                assign masked_request_higher[i] = |masked_request[PORTS-1:i+1];
            end
        end
        assign request_winner[i] = request[i] & ~request_higher[i];
        assign masked_request_winner[i] = masked_request[i] & ~masked_request_higher[i];
    end
endgenerate

wire use_masked = ARB_TYPE_ROUND_ROBIN && masked_request_valid;
wire [PORTS-1:0] selected_winner = use_masked ? masked_request_winner : request_winner;
wire [PORTS-1:0] selected_mask = use_masked ? masked_request_higher : request_higher;
wire [$clog2(PORTS)-1:0] selected_index;

generate
    for (b = 0; b < ENC_WIDTH; b = b + 1) begin : encode_bits
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

wire hold_grant = (ARB_BLOCK && !ARB_BLOCK_ACK && (|(grant_reg & request))) ||
                  (ARB_BLOCK && ARB_BLOCK_ACK && grant_valid_reg && !(|(grant_reg & acknowledge)));

always @* begin
    grant_next = selected_winner;
    grant_valid_next = request_valid;
    grant_encoded_next = selected_index;
    mask_next = mask_reg;

    if (ARB_TYPE_ROUND_ROBIN && request_valid && !hold_grant)
        mask_next = selected_mask;

    if (hold_grant) begin
        grant_next = grant_reg;
        grant_valid_next = grant_valid_reg;
        grant_encoded_next = grant_encoded_reg;
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

/* Original standalone helper interface and behavior retained. */
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
wire [W/2-1:0] stage_valid[LEVELS-1:0];
wire [W/2-1:0] stage_enc[LEVELS-1:0];
genvar l, n;
generate
    for (n = 0; n < W/2; n = n + 1) begin : loop_in
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin
            assign stage_enc[0][n] = !input_padded[n*2];
        end else begin
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end
    for (l = 1; l < LEVELS; l = l + 1) begin : loop_levels
        for (n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
            assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2] ? {1'b0, stage_enc[l-1][(n*2+1)*l-1:n*2*l]} : {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
            end else begin
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2+1] ? {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]} : {1'b0, stage_enc[l-1][(n*2+1)*l-1:n*2*l]};
            end
        end
    end
endgenerate
assign output_valid = stage_valid[LEVELS-1];
assign output_encoded = stage_enc[LEVELS-1];
assign output_unencoded = 1 << output_encoded;
endmodule

`resetall
