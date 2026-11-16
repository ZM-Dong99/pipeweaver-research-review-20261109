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
wire [PORTS-1:0] request_prefix;
wire [PORTS-1:0] masked_request_prefix;
wire [PORTS-1:0] request_winner;
wire [PORTS-1:0] masked_request_winner;
wire request_valid = |request;
wire masked_request_valid = |masked_request;
wire [$clog2(PORTS)-1:0] request_index;
wire [$clog2(PORTS)-1:0] masked_request_index;
wire [PORTS-1:0] request_mask;
wire [PORTS-1:0] masked_request_mask;

/* Each prefix says that a higher-priority request exists.  It also
 * directly represents the round-robin mask following this arbitration.
 */
genvar p;
generate
    for (p = 0; p < PORTS; p = p+1) begin : prefix_logic
        if (ARB_LSB_HIGH_PRIORITY) begin : low_priority_first
            if (p == 0) begin : edge_bit
                assign request_prefix[p] = 1'b0;
                assign masked_request_prefix[p] = 1'b0;
            end else begin : other_bits
                assign request_prefix[p] = |request[p-1:0];
                assign masked_request_prefix[p] = |masked_request[p-1:0];
            end
        end else begin : high_priority_first
            if (p == PORTS-1) begin : edge_bit
                assign request_prefix[p] = 1'b0;
                assign masked_request_prefix[p] = 1'b0;
            end else begin : other_bits
                assign request_prefix[p] = |request[PORTS-1:p+1];
                assign masked_request_prefix[p] = |masked_request[PORTS-1:p+1];
            end
        end
    end
endgenerate

assign request_winner = request & ~request_prefix;
assign masked_request_winner = masked_request & ~masked_request_prefix;

/* Encode an already one-hot result: there is no priority mux tree here. */
reg [$clog2(PORTS)-1:0] request_index_comb;
reg [$clog2(PORTS)-1:0] masked_request_index_comb;
integer k;
always @* begin
    request_index_comb = 0;
    masked_request_index_comb = 0;
    for (k = 0; k < PORTS; k = k+1) begin
        request_index_comb = request_index_comb |
            ({$bits(request_index_comb){request_winner[k]}} & k);
        masked_request_index_comb = masked_request_index_comb |
            ({$bits(masked_request_index_comb){masked_request_winner[k]}} & k);
    end
end

/* Preserve the reference encoder's defined outputs even for empty input. */
localparam EMPTY_INDEX = ARB_LSB_HIGH_PRIORITY ?
    (PORTS > 2 ? 2**$clog2(PORTS)-1 : 1) : 0;
assign request_index = request_valid ? request_index_comb : EMPTY_INDEX;
assign masked_request_index = masked_request_valid ? masked_request_index_comb : EMPTY_INDEX;
assign request_mask = request_valid ? request_winner : (1 << EMPTY_INDEX);
assign masked_request_mask = masked_request_valid ? masked_request_winner : (1 << EMPTY_INDEX);

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
            if (masked_request_valid) begin
                grant_next = masked_request_mask;
                grant_encoded_next = masked_request_index;
                mask_next = masked_request_prefix;
            end else begin
                grant_next = request_mask;
                grant_encoded_next = request_index;
                mask_next = request_prefix;
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

/* Standalone helper retains the reference interface and parameter behavior. */
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
generate
    genvar l, n;
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

`resetall
