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
    if (WIDTH == 256 && !LSB_HIGH_PRIORITY && LEVELS == 8 && W == 256) begin : fast_msb_256
        wire [15:0] group_valid;
        wire [15:0] group_clear;
        wire [15:0] group_hot;
        wire [15:0] local_hot [0:15];
        wire [15:0] low_terms [0:3];
        wire [15:0] high_terms [0:3];

        genvar g, j, k;
        for (g = 0; g < 16; g = g + 1) begin : groups
            assign group_valid[g] = |input_unencoded[g*16 +: 16];
            if (g == 15) begin : top_group
                assign group_clear[g] = 1'b1;
            end else begin : lower_group
                assign group_clear[g] = ~(|group_valid[15:g+1]);
            end
            assign group_hot[g] = group_valid[g] & group_clear[g];

            for (j = 0; j < 16; j = j + 1) begin : positions
                if (j == 15) begin : top_position
                    assign local_hot[g][j] = input_unencoded[g*16+j];
                end else begin : lower_position
                    assign local_hot[g][j] = input_unencoded[g*16+j] &
                        ~(|input_unencoded[g*16+15:g*16+j+1]);
                end
                if (g == 0 && j == 0) begin : zero_default
                    assign output_unencoded[g*16+j] = group_clear[g] &
                        ~(|input_unencoded[15:1]);
                end else begin : ordinary_output
                    assign output_unencoded[g*16+j] = group_clear[g] & local_hot[g][j];
                end
            end

            assign low_terms[0][g] = group_clear[g] & (|(local_hot[g] & 16'hAAAA));
            assign low_terms[1][g] = group_clear[g] & (|(local_hot[g] & 16'hCCCC));
            assign low_terms[2][g] = group_clear[g] & (|(local_hot[g] & 16'hF0F0));
            assign low_terms[3][g] = group_clear[g] & (|(local_hot[g] & 16'hFF00));

            for (k = 0; k < 4; k = k + 1) begin : high_code_terms
                if ((g & (1 << k)) != 0) begin : included
                    assign high_terms[k][g] = group_hot[g];
                end else begin : excluded
                    assign high_terms[k][g] = 1'b0;
                end
            end
        end

        for (k = 0; k < 4; k = k + 1) begin : encode
            assign output_encoded[k] = |low_terms[k];
            assign output_encoded[k+4] = |high_terms[k];
        end
        assign output_valid = |group_valid;
    end else begin : reference_parameters
        wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];
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

`default_nettype wire
