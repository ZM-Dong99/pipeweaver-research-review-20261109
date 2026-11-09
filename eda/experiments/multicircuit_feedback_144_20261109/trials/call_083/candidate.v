`resetall
`timescale 1ns / 1ps
`default_nettype none

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

generate
if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast
    wire [63:0] v4;
    wire [15:0] v16;
    wire [3:0] v64;
    wire [3:0] higher64;
    wire [15:0] higher16;
    wire [63:0] higher4;
    wire [3:0] enable64;
    wire [15:0] enable16;
    wire [63:0] enable4;
    wire [63:0] enc0_terms, enc1_terms;
    wire [15:0] enc2_terms, enc3_terms;
    wire [3:0] enc4_terms, enc5_terms;

    for (genvar q = 0; q < 4; q = q + 1) begin : quarters
        assign v64[q] = |v16[q*4 +: 4];
        if (q == 3) begin
            assign higher64[q] = 1'b0;
        end else begin
            assign higher64[q] = |v64[3:q+1];
        end
        assign enable64[q] = ~higher64[q];
        assign enc4_terms[q] = enable64[q] &
            (v16[q*4+3] | (v16[q*4+1] & ~v16[q*4+2]));
        assign enc5_terms[q] = enable64[q] & (|v16[q*4+2 +: 2]);
    end

    for (genvar b = 0; b < 16; b = b + 1) begin : blocks
        assign v16[b] = |v4[b*4 +: 4];
        if (b % 4 == 3) begin
            assign higher16[b] = 1'b0;
        end else begin
            assign higher16[b] = |v16[(b/4)*4+3:b+1];
        end
        assign enable16[b] = ~(higher64[b/4] | higher16[b]);
        assign enc2_terms[b] = enable16[b] &
            (v4[b*4+3] | (v4[b*4+1] & ~v4[b*4+2]));
        assign enc3_terms[b] = enable16[b] & (|v4[b*4+2 +: 2]);
    end

    for (genvar n = 0; n < 64; n = n + 1) begin : nibbles
        assign v4[n] = |input_unencoded[n*4 +: 4];
        if (n % 4 == 3) begin
            assign higher4[n] = 1'b0;
        end else begin
            assign higher4[n] = |v4[(n/4)*4+3:n+1];
        end
        assign enable4[n] = ~(higher64[n/16] | higher16[n/4] | higher4[n]);
        assign enc0_terms[n] = enable4[n] &
            (input_unencoded[n*4+3] |
             (input_unencoded[n*4+1] & ~input_unencoded[n*4+2]));
        assign enc1_terms[n] = enable4[n] & (|input_unencoded[n*4+2 +: 2]);
        for (genvar k = 0; k < 4; k = k + 1) begin : bits_out
            if (n == 0 && k == 0) begin
                assign output_unencoded[n*4+k] = enable4[n] &
                    ~(|input_unencoded[n*4+3:n*4+1]);
            end else if (k == 3) begin
                assign output_unencoded[n*4+k] = enable4[n] & input_unencoded[n*4+k];
            end else begin
                assign output_unencoded[n*4+k] = enable4[n] & input_unencoded[n*4+k] &
                    ~(|input_unencoded[n*4+3:n*4+k+1]);
            end
        end
    end

    assign output_valid = |v64;
    assign output_encoded[0] = |enc0_terms;
    assign output_encoded[1] = |enc1_terms;
    assign output_encoded[2] = |enc2_terms;
    assign output_encoded[3] = |enc3_terms;
    assign output_encoded[4] = |enc4_terms;
    assign output_encoded[5] = |enc5_terms;
    assign output_encoded[6] = v64[3] | (v64[1] & ~v64[2]);
    assign output_encoded[7] = |v64[3:2];
end else begin : general_case
    wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W/2-1:0] stage_valid[LEVELS-1:0];
    wire [W/2-1:0] stage_enc[LEVELS-1:0];
    for (genvar n = 0; n < W/2; n = n + 1) begin : pairs
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin
            assign stage_enc[0][n] = !input_padded[n*2];
        end else begin
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end
    for (genvar l = 1; l < LEVELS; l = l + 1) begin : levels
        for (genvar n = 0; n < W/(2*2**l); n = n + 1) begin : nodes
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
    assign output_valid = stage_valid[LEVELS-1];
    assign output_encoded = stage_enc[LEVELS-1];
    assign output_unencoded = 1 << output_encoded;
end
endgenerate
endmodule

`resetall
