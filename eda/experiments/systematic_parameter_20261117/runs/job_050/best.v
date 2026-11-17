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
if (WIDTH == 128 && LSB_HIGH_PRIORITY == 0 && LEVELS == 7 && W == 128) begin : fast_msb128
    wire [15:0] group_valid;
    wire [15:0] group_enable;
    wire [15:0] group_win;
    wire [15:0] low_code0;
    wire [15:0] low_code1;
    wire [15:0] low_code2;
    wire [15:0] high_code0;
    wire [15:0] high_code1;
    wire [15:0] high_code2;
    wire [15:0] high_code3;

    genvar g, j;
    for (g = 0; g < 16; g = g + 1) begin : groups
        wire [7:0] x;
        wire [7:0] local_win;
        assign x = input_unencoded[g*8 +: 8];
        assign group_valid[g] = |x;
        if (g == 15) begin : top_group
            assign group_enable[g] = 1'b1;
        end else begin : lower_group
            assign group_enable[g] = ~(|group_valid[15:g+1]);
        end
        assign group_win[g] = group_valid[g] & group_enable[g];

        for (j = 0; j < 8; j = j + 1) begin : bits_in_group
            if (j == 7) begin : top_bit
                assign local_win[j] = x[j];
            end else begin : lower_bit
                assign local_win[j] = x[j] & ~(|x[7:j+1]);
            end
            if (g == 0 && j == 0) begin : default_bit
                // The reference emits one at bit zero even for an empty input.
                assign output_unencoded[g*8+j] = group_enable[g] & ~(|x[7:1]);
            end else begin : normal_bit
                assign output_unencoded[g*8+j] = group_enable[g] & local_win[j];
            end
        end

        assign low_code0[g] = group_enable[g] & (|(local_win & 8'haa));
        assign low_code1[g] = group_enable[g] & (|(local_win & 8'hcc));
        assign low_code2[g] = group_enable[g] & (|(local_win & 8'hf0));
        assign high_code0[g] = (g % 2) ? group_win[g] : 1'b0;
        assign high_code1[g] = ((g / 2) % 2) ? group_win[g] : 1'b0;
        assign high_code2[g] = ((g / 4) % 2) ? group_win[g] : 1'b0;
        assign high_code3[g] = ((g / 8) % 2) ? group_win[g] : 1'b0;
    end

    assign output_valid = |group_valid;
    assign output_encoded = {(|high_code3), (|high_code2),
                             (|high_code1), (|high_code0),
                             (|low_code2), (|low_code1), (|low_code0)};
end else begin : original_parameter_behavior
    wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W/2-1:0] stage_valid[LEVELS-1:0];
    wire [W/2-1:0] stage_enc[LEVELS-1:0];
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
