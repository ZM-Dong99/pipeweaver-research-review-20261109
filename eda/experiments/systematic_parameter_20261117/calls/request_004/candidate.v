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
        if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast_msb256
            wire [15:0] group_valid;
            wire [15:0] group_enable;
            wire [15:0] group_selected;
            wire [15:0] local_hot [0:15];
            genvar g, j, b;
            for (g = 0; g < 16; g = g + 1) begin : groups
                assign group_valid[g] = |input_unencoded[g*16 +: 16];
                if (g == 15) begin : top_group
                    assign group_enable[g] = 1'b1;
                end else begin : other_group
                    assign group_enable[g] = ~(|group_valid[15:g+1]);
                end
                assign group_selected[g] = group_valid[g] & group_enable[g];
                for (j = 0; j < 16; j = j + 1) begin : local_bits
                    if (j == 15) begin : top_bit
                        assign local_hot[g][j] = input_unencoded[g*16+j];
                    end else begin : other_bit
                        assign local_hot[g][j] = input_unencoded[g*16+j] &
                            ~(|input_unencoded[g*16+15:g*16+j+1]);
                    end
                    if (g != 0 || j != 0) begin : ordinary_output
                        assign output_unencoded[g*16+j] = local_hot[g][j] & group_enable[g];
                    end
                end
            end

            // The reference decodes index zero even when the input is empty.
            assign output_unencoded[0] = ~(|input_unencoded[255:1]);
            assign output_valid = |group_valid;

            for (b = 0; b < 4; b = b + 1) begin : low_encoded_bits
                wire [15:0] terms;
                for (g = 0; g < 16; g = g + 1) begin : group_terms
                    wire [15:0] selected_local_bits;
                    for (j = 0; j < 16; j = j + 1) begin : mask_bits
                        if ((j & (1 << b)) != 0) begin : included
                            assign selected_local_bits[j] = local_hot[g][j];
                        end else begin : excluded
                            assign selected_local_bits[j] = 1'b0;
                        end
                    end
                    assign terms[g] = group_enable[g] & (|selected_local_bits);
                end
                assign output_encoded[b] = |terms;
            end
            for (b = 0; b < 4; b = b + 1) begin : high_encoded_bits
                wire [15:0] terms;
                for (g = 0; g < 16; g = g + 1) begin : group_terms
                    if ((g & (1 << b)) != 0) begin : included
                        assign terms[g] = group_selected[g];
                    end else begin : excluded
                        assign terms[g] = 1'b0;
                    end
                end
                assign output_encoded[b+4] = |terms;
            end
        end else begin : general_encoder
            wire [W-1:0] padded;
            wire [W/2-1:0] valid_tree [0:LEVELS-1];
            wire [W/2-1:0] code_tree [0:LEVELS-1];
            assign padded = {{W-WIDTH{1'b0}}, input_unencoded};
            genvar n, l;
            for (n = 0; n < W/2; n = n + 1) begin : pairs
                assign valid_tree[0][n] = |padded[2*n+1:2*n];
                if (LSB_HIGH_PRIORITY) begin : low_priority_index
                    assign code_tree[0][n] = !padded[2*n];
                end else begin : high_priority_index
                    assign code_tree[0][n] = padded[2*n+1];
                end
            end
            for (l = 1; l < LEVELS; l = l + 1) begin : levels
                for (n = 0; n < W/(2*2**l); n = n + 1) begin : nodes
                    assign valid_tree[l][n] = |valid_tree[l-1][2*n+1:2*n];
                    if (LSB_HIGH_PRIORITY) begin : low_first
                        assign code_tree[l][(n+1)*(l+1)-1:n*(l+1)] =
                            valid_tree[l-1][2*n] ?
                            {1'b0, code_tree[l-1][(2*n+1)*l-1:2*n*l]} :
                            {1'b1, code_tree[l-1][(2*n+2)*l-1:(2*n+1)*l]};
                    end else begin : high_first
                        assign code_tree[l][(n+1)*(l+1)-1:n*(l+1)] =
                            valid_tree[l-1][2*n+1] ?
                            {1'b1, code_tree[l-1][(2*n+2)*l-1:(2*n+1)*l]} :
                            {1'b0, code_tree[l-1][(2*n+1)*l-1:2*n*l]};
                    end
                end
            end
            assign output_valid = valid_tree[LEVELS-1];
            assign output_encoded = code_tree[LEVELS-1];
            assign output_unencoded = 1 << output_encoded;
        end
    endgenerate
endmodule
`default_nettype wire
