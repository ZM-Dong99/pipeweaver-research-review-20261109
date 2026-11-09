`timescale 1ns / 1ps
`default_nettype none

module priority_encoder #(
    parameter WIDTH = 4,
    parameter LSB_HIGH_PRIORITY = 0
)(
    input  wire [WIDTH-1:0] input_unencoded,
    output wire output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0] output_unencoded
);

parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1;
parameter W = 2**LEVELS;

generate
    if (WIDTH == 256 && !LSB_HIGH_PRIORITY && LEVELS == 8 && W == 256) begin : fast_msb256
        wire [15:0] group_valid;
        wire [15:0] group_enable;
        wire [15:0] group_winner;
        wire [15:0] low_terms [3:0];
        wire [15:0] high_terms [3:0];

        genvar g, j, b;
        for (g = 0; g < 16; g = g + 1) begin : groups
            wire [15:0] data;
            wire [15:0] local_winner;
            wire [3:0] local_code;

            assign data = input_unencoded[g*16 +: 16];
            assign group_valid[g] = |data;
            if (g == 15) begin : top_group
                assign group_enable[g] = 1'b1;
            end else begin : lower_group
                assign group_enable[g] = ~(|group_valid[15:g+1]);
            end
            assign group_winner[g] = group_valid[g] & group_enable[g];

            for (j = 0; j < 16; j = j + 1) begin : positions
                wire higher_local;
                if (j == 15) begin : top_position
                    assign higher_local = 1'b0;
                end else begin : lower_position
                    assign higher_local = |data[15:j+1];
                end
                assign local_winner[j] = data[j] & ~higher_local;
                if (g == 0 && j == 0) begin : default_position
                    // The original decoder asserts bit zero even on empty input.
                    assign output_unencoded[g*16+j] = group_enable[g] & ~higher_local;
                end else begin : ordinary_position
                    assign output_unencoded[g*16+j] = group_enable[g] & local_winner[j];
                end
            end

            assign local_code[0] = |(local_winner & 16'haaaa);
            assign local_code[1] = |(local_winner & 16'hcccc);
            assign local_code[2] = |(local_winner & 16'hf0f0);
            assign local_code[3] = |(local_winner & 16'hff00);

            for (b = 0; b < 4; b = b + 1) begin : code_terms
                assign low_terms[b][g] = local_code[b] & group_enable[g];
                if ((g & (1 << b)) != 0) begin : high_set
                    assign high_terms[b][g] = group_winner[g];
                end else begin : high_clear
                    assign high_terms[b][g] = 1'b0;
                end
            end
        end

        for (b = 0; b < 4; b = b + 1) begin : combine_code
            assign output_encoded[b] = |low_terms[b];
            assign output_encoded[b+4] = |high_terms[b];
        end
        assign output_valid = |group_valid;
    end else begin : general_configuration
        // Preserve the original parameterized tree, including empty-input
        // encoding, padding, parameter overrides, and assignment truncation.
        wire [W-1:0] input_padded;
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];
        assign input_padded = {{W-WIDTH{1'b0}}, input_unencoded};

        genvar l, n;
        for (n = 0; n < W/2; n = n + 1) begin : input_pairs
            assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : lsb_pair
                assign stage_enc[0][n] = !input_padded[n*2];
            end else begin : msb_pair
                assign stage_enc[0][n] = input_padded[n*2+1];
            end
        end
        for (l = 1; l < LEVELS; l = l + 1) begin : levels
            for (n = 0; n < W/(2*2**l); n = n + 1) begin : nodes
                assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin : lsb_node
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                        stage_valid[l-1][n*2] ?
                        {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                        {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : msb_node
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
