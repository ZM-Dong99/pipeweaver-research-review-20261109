`resetall
`timescale 1ns / 1ps
`default_nettype none

// Parallel priority selection.  The next round-robin mask is computed
// directly from request prefixes/suffixes, not from an encoded index.
module arbiter_select #(
    parameter PORTS = 4,
    parameter LSB_HIGH_PRIORITY = 0,
    parameter EW = $clog2(PORTS) > 0 ? $clog2(PORTS) : 2
)(
    input wire [PORTS-1:0] req,
    output wire valid,
    output wire [PORTS-1:0] winner,
    output wire [EW-1:0] index,
    output wire [PORTS-1:0] following_mask
);
    assign valid = |req;
    genvar i, b;
    generate
        for (i = 0; i < PORTS; i = i+1) begin : select_bit
            if (LSB_HIGH_PRIORITY) begin : low_first
                if (i == 0) begin : edge_bit
                    assign winner[i] = req[i];
                    assign following_mask[i] = 1'b0;
                end else begin : inner_bit
                    assign winner[i] = req[i] & ~(|req[i-1:0]);
                    assign following_mask[i] = |req[i-1:0];
                end
            end else begin : high_first
                if (i == PORTS-1) begin : edge_bit
                    assign winner[i] = req[i];
                    assign following_mask[i] = 1'b0;
                end else begin : inner_bit
                    assign winner[i] = req[i] & ~(|req[PORTS-1:i+1]);
                    assign following_mask[i] = |req[PORTS-1:i+1];
                end
            end
        end
        for (b = 0; b < EW; b = b+1) begin : encode_bit
            wire [PORTS-1:0] terms;
            for (i = 0; i < PORTS; i = i+1) begin : encode_term
                if ((i >> b) & 1) begin : included
                    assign terms[i] = winner[i];
                end else begin : excluded
                    assign terms[i] = 1'b0;
                end
            end
            assign index[b] = |terms;
        end
    endgenerate
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

    wire raw_valid, eligible_valid;
    wire [PORTS-1:0] raw_winner, eligible_winner;
    wire [PORTS-1:0] raw_following, eligible_following;
    wire [$clog2(PORTS)-1:0] raw_index, eligible_index;

    arbiter_select #(
        .PORTS(PORTS),
        .LSB_HIGH_PRIORITY(ARB_LSB_HIGH_PRIORITY)
    ) select_raw (
        .req(request),
        .valid(raw_valid),
        .winner(raw_winner),
        .index(raw_index),
        .following_mask(raw_following)
    );

    arbiter_select #(
        .PORTS(PORTS),
        .LSB_HIGH_PRIORITY(ARB_LSB_HIGH_PRIORITY)
    ) select_eligible (
        .req(request & mask_reg),
        .valid(eligible_valid),
        .winner(eligible_winner),
        .index(eligible_index),
        .following_mask(eligible_following)
    );

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
        end else if (raw_valid) begin
            grant_valid_next = 1'b1;
            if (ARB_TYPE_ROUND_ROBIN) begin
                if (eligible_valid) begin
                    grant_next = eligible_winner;
                    grant_encoded_next = eligible_index;
                    mask_next = eligible_following;
                end else begin
                    grant_next = raw_winner;
                    grant_encoded_next = raw_index;
                    mask_next = raw_following;
                end
            end else begin
                grant_next = raw_winner;
                grant_encoded_next = raw_index;
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

// Original general-purpose priority encoder interface and invalid-input
// behavior retained, including its overridable LEVELS and W parameters.
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
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2] ? {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} : {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2+1] ? {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]} : {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]};
                end
            end
        end
    endgenerate
    assign output_valid = stage_valid[LEVELS-1];
    assign output_encoded = stage_enc[LEVELS-1];
    assign output_unencoded = 1 << output_encoded;
endmodule

`resetall
