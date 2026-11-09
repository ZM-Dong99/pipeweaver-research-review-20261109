`resetall
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
    if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast_256
        wire [15:0] group_valid;
        wire [15:0] group_enable;
        wire [15:0] group_selected;
        wire [3:0] local_encoded [0:15];
        wire [15:0] encoded_terms [0:3];
        wire [15:0] group_code_terms [0:3];

        genvar g, k, b;
        for (g = 0; g < 16; g = g + 1) begin : groups
            wire [15:0] local_hit;
            wire [15:0] local_code_terms [0:3];

            assign group_valid[g] = |input_unencoded[g*16 +: 16];
            if (g == 15) begin : top_group
                assign group_enable[g] = 1'b1;
            end else begin : lower_group
                assign group_enable[g] = ~(|group_valid[15:g+1]);
            end
            assign group_selected[g] = group_valid[g] & group_enable[g];

            for (k = 0; k < 16; k = k + 1) begin : bits
                if (k == 15) begin : top_bit
                    assign local_hit[k] = input_unencoded[g*16+k];
                end else begin : lower_bit
                    assign local_hit[k] = input_unencoded[g*16+k] &
                        ~(|input_unencoded[g*16+15:g*16+k+1]);
                end

                if (g == 0 && k == 0) begin : zero_default
                    assign output_unencoded[g*16+k] = group_enable[g] &
                        ~(|input_unencoded[15:1]);
                end else begin : ordinary_output
                    assign output_unencoded[g*16+k] = group_enable[g] & local_hit[k];
                end

                for (b = 0; b < 4; b = b + 1) begin : local_terms
                    if ((k & (1 << b)) != 0) begin : included
                        assign local_code_terms[b][k] = local_hit[k];
                    end else begin : excluded
                        assign local_code_terms[b][k] = 1'b0;
                    end
                end
            end

            for (b = 0; b < 4; b = b + 1) begin : encode_group
                assign local_encoded[g][b] = |local_code_terms[b];
                assign encoded_terms[b][g] = local_encoded[g][b] & group_enable[g];
                if ((g & (1 << b)) != 0) begin : included
                    assign group_code_terms[b][g] = group_selected[g];
                end else begin : excluded
                    assign group_code_terms[b][g] = 1'b0;
                end
            end
        end

        for (b = 0; b < 4; b = b + 1) begin : final_encode
            assign output_encoded[b] = |encoded_terms[b];
            assign output_encoded[b+4] = |group_code_terms[b];
        end
        assign output_valid = |group_valid;

    end else begin : general_tree
        wire [W-1:0] input_padded;
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];
        assign input_padded = {{W-WIDTH{1'b0}}, input_unencoded};

        genvar l, n;
        for (n = 0; n < W/2; n = n + 1) begin : pairs
            assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : low_priority_index
                assign stage_enc[0][n] = !input_padded[n*2];
            end else begin : high_priority_index
                assign stage_enc[0][n] = input_padded[n*2+1];
            end
        end
        for (l = 1; l < LEVELS; l = l + 1) begin : levels
            for (n = 0; n < W/(2*2**l); n = n + 1) begin : nodes
                assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin : low_priority_index
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                        stage_valid[l-1][n*2] ?
                        {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                        {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : high_priority_index
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
