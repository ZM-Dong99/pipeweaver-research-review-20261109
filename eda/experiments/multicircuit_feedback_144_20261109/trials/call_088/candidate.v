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
    if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast256
        wire [15:0] group_valid;
        wire [15:0] group_allow;
        wire [15:0] group_selected;
        wire [15:0] low_terms [3:0];

        genvar g, i, b;
        for (g = 0; g < 16; g = g + 1) begin : groups
            wire [15:0] local_input;
            wire [15:0] local_winner;
            wire [3:0] local_code;
            assign local_input = input_unencoded[g*16 +: 16];
            assign group_valid[g] = |local_input;
            if (g == 15) begin : top_group
                assign group_allow[g] = 1'b1;
            end else begin : lower_group
                assign group_allow[g] = ~(|group_valid[15:g+1]);
            end
            assign group_selected[g] = group_valid[g] & group_allow[g];

            for (i = 0; i < 16; i = i + 1) begin : positions
                wire local_allow;
                if (i == 15) begin : top_position
                    assign local_allow = 1'b1;
                end else begin : lower_position
                    assign local_allow = ~(|local_input[15:i+1]);
                end
                assign local_winner[i] = local_input[i] & local_allow;
                if (g == 0 && i == 0) begin : zero_default
                    assign output_unencoded[g*16+i] = group_allow[g] & local_allow;
                end else begin : ordinary_position
                    assign output_unencoded[g*16+i] = group_allow[g] & local_winner[i];
                end
            end

            assign local_code[0] = |(local_winner & 16'hAAAA);
            assign local_code[1] = |(local_winner & 16'hCCCC);
            assign local_code[2] = |(local_winner & 16'hF0F0);
            assign local_code[3] = |(local_winner & 16'hFF00);
            for (b = 0; b < 4; b = b + 1) begin : code_terms
                assign low_terms[b][g] = local_code[b] & group_allow[g];
            end
        end

        for (b = 0; b < 4; b = b + 1) begin : low_encode
            assign output_encoded[b] = |low_terms[b];
        end
        assign output_encoded[4] = |(group_selected & 16'hAAAA);
        assign output_encoded[5] = |(group_selected & 16'hCCCC);
        assign output_encoded[6] = |(group_selected & 16'hF0F0);
        assign output_encoded[7] = |(group_selected & 16'hFF00);
        assign output_valid = |group_valid;
    end else begin : general_tree
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
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2] ? {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} : {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : msb
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2+1] ? {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]} : {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]};
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
