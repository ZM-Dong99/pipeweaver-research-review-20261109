`resetall
`timescale 1ns / 1ps
`default_nettype none

module pe16_parallel (
    input wire [15:0] x,
    output wire valid,
    output wire [3:0] encoded,
    output wire [15:0] winner,
    output wire [15:0] enable
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_suffix
            if (i == 15) begin : top_bit
                assign enable[i] = 1'b1;
            end else begin : other_bit
                assign enable[i] = ~(|x[15:i+1]);
            end
            assign winner[i] = x[i] & enable[i];
        end
    endgenerate
    assign valid = |x;
    assign encoded[3] = |x[15:8];
    assign encoded[2] = (|x[15:12]) |
                        ((~(|x[15:8])) & (|x[7:4]));
    assign encoded[1] = (|x[15:14]) |
                        ((~(|x[15:12])) & (|x[11:10])) |
                        ((~(|x[15:8])) & (|x[7:6])) |
                        ((~(|x[15:4])) & (|x[3:2]));
    assign encoded[0] = winner[15] | winner[13] | winner[11] |
                        winner[9] | winner[7] | winner[5] |
                        winner[3] | winner[1];
endmodule

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
            wire [15:0] group_enable;
            wire [15:0] group_winner;
            wire [3:0] group_encoded;
            wire [3:0] local_encoded [0:15];
            wire [15:0] local_winner [0:15];
            wire [15:0] local_enable [0:15];
            wire [15:0] low_terms [0:3];
            genvar g, b;
            for (g = 0; g < 16; g = g + 1) begin : blocks
                pe16_parallel local_pe (
                    .x(input_unencoded[g*16 +: 16]),
                    .valid(group_valid[g]),
                    .encoded(local_encoded[g]),
                    .winner(local_winner[g]),
                    .enable(local_enable[g])
                );
                for (b = 0; b < 4; b = b + 1) begin : encode_terms
                    assign low_terms[b][g] = local_encoded[g][b] & group_enable[g];
                end
                if (g == 0) begin : bottom_block
                    assign output_unencoded[15:1] = local_winner[g][15:1] & {15{group_enable[g]}};
                    assign output_unencoded[0] = group_enable[0] & local_enable[0][0];
                end else begin : remaining_blocks
                    assign output_unencoded[g*16 +: 16] = local_winner[g] & {16{group_enable[g]}};
                end
            end
            pe16_parallel group_pe (
                .x(group_valid),
                .valid(output_valid),
                .encoded(group_encoded),
                .winner(group_winner),
                .enable(group_enable)
            );
            assign output_encoded[7:4] = group_encoded;
            for (b = 0; b < 4; b = b + 1) begin : encode_reduce
                assign output_encoded[b] = |low_terms[b];
            end
        end else begin : general_tree
            wire [W-1:0] padded = {{W-WIDTH{1'b0}}, input_unencoded};
            wire [W/2-1:0] v [LEVELS-1:0];
            wire [W/2-1:0] e [LEVELS-1:0];
            genvar l, n;
            for (n = 0; n < W/2; n = n + 1) begin : pairs
                assign v[0][n] = |padded[n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin : low_first
                    assign e[0][n] = !padded[n*2];
                end else begin : high_first
                    assign e[0][n] = padded[n*2+1];
                end
            end
            for (l = 1; l < LEVELS; l = l + 1) begin : levels
                for (n = 0; n < W/(2*2**l); n = n + 1) begin : nodes
                    assign v[l][n] = |v[l-1][n*2+1:n*2];
                    if (LSB_HIGH_PRIORITY) begin : low_first
                        assign e[l][(n+1)*(l+1)-1:n*(l+1)] = v[l-1][n*2] ?
                            {1'b0,e[l-1][(n*2+1)*l-1:n*2*l]} :
                            {1'b1,e[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                    end else begin : high_first
                        assign e[l][(n+1)*(l+1)-1:n*(l+1)] = v[l-1][n*2+1] ?
                            {1'b1,e[l-1][(n*2+2)*l-1:(n*2+1)*l]} :
                            {1'b0,e[l-1][(n*2+1)*l-1:n*2*l]};
                    end
                end
            end
            assign output_valid = v[LEVELS-1];
            assign output_encoded = e[LEVELS-1];
            assign output_unencoded = 1 << output_encoded;
        end
    endgenerate
endmodule

`resetall
