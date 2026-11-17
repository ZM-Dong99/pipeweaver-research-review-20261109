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
if (WIDTH == 128 && !LSB_HIGH_PRIORITY && LEVELS == 7 && W == 128) begin : fast_msb128
    wire [15:0] group_valid;
    wire [15:0] group_enable;
    wire [15:0] group_selected;
    wire [15:0] low_plane [2:0];

    genvar g, b, k;
    for (g = 0; g < 16; g = g + 1) begin : groups
        wire [7:0] local_input;
        wire [7:0] local_selected;
        wire [2:0] local_encoded;

        assign local_input = input_unencoded[g*8 +: 8];
        assign group_valid[g] = |local_input;
        if (g == 15) begin : top_group
            assign group_enable[g] = 1'b1;
        end else begin : lower_group
            assign group_enable[g] = ~(|group_valid[15:g+1]);
        end
        assign group_selected[g] = group_valid[g] & group_enable[g];

        for (b = 0; b < 8; b = b + 1) begin : bits_in_group
            if (b == 7) begin : top_bit
                assign local_selected[b] = local_input[b];
            end else begin : lower_bit
                assign local_selected[b] = local_input[b] & ~(|local_input[7:b+1]);
            end
            if (g == 0 && b == 0) begin : default_bit
                // The reference decodes index zero even when no input is set.
                assign output_unencoded[0] = ~(|input_unencoded[127:1]);
            end else begin : ordinary_bit
                assign output_unencoded[g*8+b] = local_selected[b] & group_enable[g];
            end
        end

        assign local_encoded[0] = |(local_selected & 8'hAA);
        assign local_encoded[1] = |(local_selected & 8'hCC);
        assign local_encoded[2] = |(local_selected & 8'hF0);
        for (k = 0; k < 3; k = k + 1) begin : encoded_planes
            assign low_plane[k][g] = local_encoded[k] & group_enable[g];
        end
    end

    assign output_valid = |group_valid;
    assign output_encoded[0] = |low_plane[0];
    assign output_encoded[1] = |low_plane[1];
    assign output_encoded[2] = |low_plane[2];
    assign output_encoded[3] = |(group_selected & 16'hAAAA);
    assign output_encoded[4] = |(group_selected & 16'hCCCC);
    assign output_encoded[5] = |(group_selected & 16'hF0F0);
    assign output_encoded[6] = |(group_selected & 16'hFF00);
end else begin : reference_parameters
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
