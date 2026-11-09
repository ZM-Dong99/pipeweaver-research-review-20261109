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
        wire [15:0] group_valid;
        wire [15:0] group_enable;
        wire [15:0] group_winner;
        wire [15:0] code_terms [3:0];

        for (genvar g = 0; g < 16; g = g + 1) begin : groups
            wire [15:0] x;
            wire [15:0] winner;
            wire [3:0] local_code;
            assign x = input_unencoded[g*16 +: 16];
            assign group_valid[g] = |x;
            if (g == 15) begin : top_group
                assign group_enable[g] = 1'b1;
            end else begin : other_group
                assign group_enable[g] = ~(|group_valid[15:g+1]);
            end
            assign group_winner[g] = group_valid[g] & group_enable[g];

            for (genvar b = 0; b < 16; b = b + 1) begin : bits
                if (b == 15) begin : top_bit
                    assign winner[b] = x[b];
                end else begin : other_bit
                    assign winner[b] = x[b] & ~(|x[15:b+1]);
                end
                if (g == 0 && b == 0) begin : default_bit
                    assign output_unencoded[g*16+b] = group_enable[g] & ~(|x[15:1]);
                end else begin : ordinary_bit
                    assign output_unencoded[g*16+b] = group_enable[g] & winner[b];
                end
            end

            assign local_code[0] = |(winner & 16'haaaa);
            assign local_code[1] = |(winner & 16'hcccc);
            assign local_code[2] = |(winner & 16'hf0f0);
            assign local_code[3] = |(winner & 16'hff00);
            for (genvar k = 0; k < 4; k = k + 1) begin : code_bits
                assign code_terms[k][g] = local_code[k] & group_enable[g];
            end
        end

        assign output_valid = |group_valid;
        assign output_encoded[0] = |code_terms[0];
        assign output_encoded[1] = |code_terms[1];
        assign output_encoded[2] = |code_terms[2];
        assign output_encoded[3] = |code_terms[3];
        assign output_encoded[4] = |(group_winner & 16'haaaa);
        assign output_encoded[5] = |(group_winner & 16'hcccc);
        assign output_encoded[6] = |(group_winner & 16'hf0f0);
        assign output_encoded[7] = |(group_winner & 16'hff00);
    end else begin : generic
        wire [W-1:0] input_padded;
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];
        assign input_padded = {{W-WIDTH{1'b0}}, input_unencoded};

        for (genvar n = 0; n < W/2; n = n + 1) begin : pairs
            assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : low
                assign stage_enc[0][n] = !input_padded[n*2];
            end else begin : high
                assign stage_enc[0][n] = input_padded[n*2+1];
            end
        end
        for (genvar l = 1; l < LEVELS; l = l + 1) begin : levels
            for (genvar n = 0; n < W/(2*2**l); n = n + 1) begin : nodes
                assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin : low
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                        stage_valid[l-1][n*2] ?
                        {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                        {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : high
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
