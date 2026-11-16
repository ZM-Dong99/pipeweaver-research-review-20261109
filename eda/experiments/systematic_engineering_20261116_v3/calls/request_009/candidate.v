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

// Shared four-way local prefixes and group prefixes.  'before' denotes
// the presence of a request with strictly higher arbitration priority.
module arbiter_priority_scan #(
    parameter WIDTH = 4,
    parameter LSB_HIGH_PRIORITY = 0
)(
    input wire [WIDTH-1:0] data,
    output wire valid,
    output wire [WIDTH-1:0] winner,
    output wire [WIDTH-1:0] before
);
    localparam GROUPS = (WIDTH+3)/4;
    localparam PAD = GROUPS*4;
    wire [PAD-1:0] padded = {{PAD-WIDTH{1'b0}}, data};
    wire [GROUPS-1:0] group_valid;
    wire [GROUPS-1:0] group_before;
    genvar g, k;
    generate
        for (g = 0; g < GROUPS; g = g+1) begin : groups
            assign group_valid[g] = |padded[g*4 +: 4];
            if (LSB_HIGH_PRIORITY) begin : low
                if (g == 0) begin : edge_group
                    assign group_before[g] = 1'b0;
                end else begin : inner_group
                    assign group_before[g] = |group_valid[g-1:0];
                end
            end else begin : high
                if (g == GROUPS-1) begin : edge_group
                    assign group_before[g] = 1'b0;
                end else begin : inner_group
                    assign group_before[g] = |group_valid[GROUPS-1:g+1];
                end
            end
            for (k = 0; k < 4; k = k+1) begin : bits_in_group
                if (g*4+k < WIDTH) begin : present
                    wire local_before;
                    if (LSB_HIGH_PRIORITY) begin : low
                        if (k == 0) begin : edge_bit
                            assign local_before = 1'b0;
                        end else begin : inner_bit
                            assign local_before = |padded[g*4+k-1:g*4];
                        end
                    end else begin : high
                        if (k == 3) begin : edge_bit
                            assign local_before = 1'b0;
                        end else begin : inner_bit
                            assign local_before = |padded[g*4+3:g*4+k+1];
                        end
                    end
                    assign before[g*4+k] = group_before[g] | local_before;
                    assign winner[g*4+k] = data[g*4+k] & ~before[g*4+k];
                end
            end
        end
    endgenerate
    assign valid = |group_valid;
endmodule

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
    wire [W-1:0] padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W-1:0] winner;
    wire [W-1:0] before;
    wire [LEVELS-1:0] encoded;
    arbiter_priority_scan #(
        .WIDTH(W), .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
    ) scan_inst (
        .data(padded), .valid(output_valid),
        .winner(winner), .before(before)
    );
    genvar b, i;
    generate
        for (b = 0; b < LEVELS; b = b+1) begin : encode
            wire [W-1:0] terms;
            for (i = 0; i < W; i = i+1) begin : term
                if ((i >> b) & 1) begin : one
                    assign terms[i] = winner[i];
                end else begin : zero
                    assign terms[i] = 1'b0;
                end
            end
            assign encoded[b] = (|terms) | (LSB_HIGH_PRIORITY && !output_valid);
        end
    endgenerate
    assign output_encoded = encoded;
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
    wire masked_request_valid;
    wire [PORTS-1:0] request_winner;
    wire [PORTS-1:0] masked_request_winner;
    wire [PORTS-1:0] request_next_mask;
    wire [PORTS-1:0] masked_request_next_mask;
    wire [PORTS-1:0] masked_request = request & mask_reg;

    arbiter_priority_scan #(
        .WIDTH(PORTS), .LSB_HIGH_PRIORITY(ARB_LSB_HIGH_PRIORITY)
    ) request_scan (
        .data(request), .valid(request_valid),
        .winner(request_winner), .before(request_next_mask)
    );
    arbiter_priority_scan #(
        .WIDTH(PORTS), .LSB_HIGH_PRIORITY(ARB_LSB_HIGH_PRIORITY)
    ) masked_scan (
        .data(masked_request), .valid(masked_request_valid),
        .winner(masked_request_winner), .before(masked_request_next_mask)
    );

    wire [PORTS-1:0] selected_winner;
    wire [PORTS-1:0] selected_mask;
    generate
        if (ARB_TYPE_ROUND_ROBIN) begin : round_robin
            // A masked winner already implies masked_request_valid; avoid
            // placing that global valid signal in its data path.
            assign selected_winner = masked_request_winner |
                (request_winner & {PORTS{!masked_request_valid}});
            assign selected_mask = masked_request_next_mask |
                (request_next_mask & {PORTS{!masked_request_valid}});
        end else begin : fixed_priority
            assign selected_winner = request_winner;
            assign selected_mask = request_next_mask;
        end
    endgenerate

    // Encode once, after combining the two one-hot arbitration results.
    localparam INDEX_BITS = $clog2(PORTS);
    wire [INDEX_BITS-1:0] selected_index;
    genvar b, i;
    generate
        for (b = 0; b < INDEX_BITS; b = b+1) begin : encode_selected
            wire [PORTS-1:0] terms;
            for (i = 0; i < PORTS; i = i+1) begin : term
                if ((i >> b) & 1) begin : one
                    assign terms[i] = selected_winner[i];
                end else begin : zero
                    assign terms[i] = 1'b0;
                end
            end
            assign selected_index[b] = |terms;
        end
        // Match the reference's unusual [-1:0] index width for PORTS=1.
        if (PORTS == 1) begin : single_port
            assign selected_index = 0;
        end
    endgenerate

    wire hold_grant = ARB_BLOCK &&
        (ARB_BLOCK_ACK ?
            (grant_valid_reg && !(|(grant_reg & acknowledge))) :
            (|(grant_reg & request)));

    always @* begin
        grant_next = selected_winner;
        grant_valid_next = request_valid;
        grant_encoded_next = selected_index;
        mask_next = mask_reg;
        if (ARB_TYPE_ROUND_ROBIN && request_valid)
            mask_next = selected_mask;
        if (hold_grant) begin
            grant_next = grant_reg;
            grant_valid_next = grant_valid_reg;
            grant_encoded_next = grant_encoded_reg;
            mask_next = mask_reg;
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
