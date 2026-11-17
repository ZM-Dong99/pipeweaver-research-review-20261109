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
if (WIDTH == 64 && LSB_HIGH_PRIORITY == 0 && LEVELS == 6 && W == 64) begin : fast64
    wire [7:0] group_valid;
    wire [7:0] group_enable;
    wire [7:0] code0;
    wire [7:0] code1;
    wire [7:0] code2;
    genvar g, b;
    for (g = 0; g < 8; g = g + 1) begin : groups
        wire [7:0] x;
        wire upper4;
        wire upper2;
        wire upper6;
        wire [2:0] local_code;
        assign x = input_unencoded[g*8 +: 8];
        assign group_valid[g] = |x;
        if (g == 7) begin : top_group
            assign group_enable[g] = 1'b1;
        end else begin : other_group
            assign group_enable[g] = ~(|group_valid[7:g+1]);
        end
        assign upper4 = |x[7:4];
        assign upper2 = |x[7:6];
        assign upper6 = |x[7:2];
        assign local_code[2] = upper4;
        assign local_code[1] = upper2 | ((~upper4) & (|x[3:2]));
        assign local_code[0] = x[7] | ((~upper2) & x[5]) |
                               ((~upper4) & x[3]) | ((~upper6) & x[1]);
        assign code0[g] = local_code[0] & group_enable[g];
        assign code1[g] = local_code[1] & group_enable[g];
        assign code2[g] = local_code[2] & group_enable[g];
        for (b = 0; b < 8; b = b + 1) begin : bits_out
            if (g == 0 && b == 0) begin : default_bit
                assign output_unencoded[0] = ~(|input_unencoded[63:1]);
            end else if (b == 7) begin : top_bit
                assign output_unencoded[g*8+b] = x[b] & group_enable[g];
            end else begin : other_bit
                assign output_unencoded[g*8+b] = x[b] &
                    (~(|x[7:b+1])) & group_enable[g];
            end
        end
    end
    assign output_valid = |group_valid;
    assign output_encoded[2:0] = {|code2, |code1, |code0};
    assign output_encoded[5] = |group_valid[7:4];
    assign output_encoded[4] = (|group_valid[7:6]) |
        ((~(|group_valid[7:4])) & (|group_valid[3:2]));
    assign output_encoded[3] = group_valid[7] |
        ((~(|group_valid[7:6])) & group_valid[5]) |
        ((~(|group_valid[7:4])) & group_valid[3]) |
        ((~(|group_valid[7:2])) & group_valid[1]);
end else begin : general_implementation
    wire [W-1:0] input_padded;
    wire [W/2-1:0] stage_valid [LEVELS-1:0];
    wire [W/2-1:0] stage_enc [LEVELS-1:0];
    assign input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    genvar l, n;
    for (n = 0; n < W/2; n = n + 1) begin : loop_in
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin : lsb
            assign stage_enc[0][n] = !input_padded[n*2];
        end else begin : msb
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end
    for (l = 1; l < LEVELS; l = l + 1) begin : loop_levels
        for (n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
            assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : lsb
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                    stage_valid[l-1][n*2] ?
                    {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                    {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
            end else begin : msb
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
