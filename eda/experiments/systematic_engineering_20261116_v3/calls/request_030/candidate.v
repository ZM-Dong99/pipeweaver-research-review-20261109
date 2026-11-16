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
    wire [WIDTH-1:0] winner;
    localparam [$clog2(WIDTH)-1:0] EMPTY_INDEX = LSB_HIGH_PRIORITY ? W-1 : 0;
    genvar i, b, j;
    generate
        for (i = 0; i < WIDTH; i = i+1) begin : g_winner
            if (LSB_HIGH_PRIORITY) begin : g_low
                if (i == 0) begin : g_edge
                    assign winner[i] = input_unencoded[i];
                end else begin : g_inner
                    assign winner[i] = input_unencoded[i] & ~(|input_unencoded[i-1:0]);
                end
            end else begin : g_high
                if (i == WIDTH-1) begin : g_edge
                    assign winner[i] = input_unencoded[i];
                end else begin : g_inner
                    assign winner[i] = input_unencoded[i] & ~(|input_unencoded[WIDTH-1:i+1]);
                end
            end
        end
        for (b = 0; b < $bits(output_encoded); b = b+1) begin : g_encode
            wire [WIDTH-1:0] terms;
            for (j = 0; j < WIDTH; j = j+1) begin : g_term
                if ((j >> b) & 1) begin : g_one
                    assign terms[j] = winner[j];
                end else begin : g_zero
                    assign terms[j] = 1'b0;
                end
            end
            assign output_encoded[b] = (|terms) | (~output_valid & EMPTY_INDEX[b]);
        end
    endgenerate
    assign output_valid = |input_unencoded;
    assign output_unencoded = winner | (output_valid ? {WIDTH{1'b0}} : ({{WIDTH{1'b0}}} | (1 << EMPTY_INDEX)));
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

    priority_encoder #(
        .WIDTH(PORTS), .LSB_HIGH_PRIORITY(ARB_LSB_HIGH_PRIORITY)
    ) priority_encoder_inst (
        .input_unencoded(request),
        .output_valid(request_valid),
        .output_encoded(request_index),
        .output_unencoded(request_mask)
    );
    priority_encoder #(
        .WIDTH(PORTS), .LSB_HIGH_PRIORITY(ARB_LSB_HIGH_PRIORITY)
    ) priority_encoder_masked (
        .input_unencoded(request & mask_reg),
        .output_valid(masked_request_valid),
        .output_encoded(masked_request_index),
        .output_unencoded(masked_request_mask)
    );

    wire [PORTS-1:0] request_next_mask;
    wire [PORTS-1:0] masked_next_mask;
    genvar k;
    generate
        for (k = 0; k < PORTS; k = k+1) begin : g_next_mask
            if (ARB_LSB_HIGH_PRIORITY) begin : g_low
                if (k == 0) begin : g_edge
                    assign request_next_mask[k] = 1'b0;
                    assign masked_next_mask[k] = 1'b0;
                end else begin : g_inner
                    assign request_next_mask[k] = |request_mask[k-1:0];
                    assign masked_next_mask[k] = |masked_request_mask[k-1:0];
                end
            end else begin : g_high
                if (k == PORTS-1) begin : g_edge
                    assign request_next_mask[k] = 1'b0;
                    assign masked_next_mask[k] = 1'b0;
                end else begin : g_inner
                    assign request_next_mask[k] = |request_mask[PORTS-1:k+1];
                    assign masked_next_mask[k] = |masked_request_mask[PORTS-1:k+1];
                end
            end
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
            grant_valid_next = 1'b1;
            if (ARB_TYPE_ROUND_ROBIN) begin
                if (masked_request_valid) begin
                    grant_next = masked_request_mask;
                    grant_encoded_next = masked_request_index;
                    mask_next = masked_next_mask;
                end else begin
                    grant_next = request_mask;
                    grant_encoded_next = request_index;
                    mask_next = request_next_mask;
                end
            end else begin
                grant_next = request_mask;
                grant_encoded_next = request_index;
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
