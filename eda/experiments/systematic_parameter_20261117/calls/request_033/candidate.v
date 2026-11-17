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
    if (WIDTH == 64 && LSB_HIGH_PRIORITY == 0 && LEVELS == 6 && W == 64) begin : fast64
        wire [7:0] group_valid;
        wire [7:0] group_enable;
        wire [7:0] group_winner;
        wire [7:0] local_winner [0:7];
        wire [2:0] local_code [0:7];
        wire [7:0] code_terms [0:2];
        genvar g, j, b;

        for (g = 0; g < 8; g = g + 1) begin : groups
            wire [7:0] x;
            assign x = input_unencoded[g*8 +: 8];
            assign group_valid[g] = |x;
            if (g == 7) begin : top_group
                assign group_enable[g] = 1'b1;
            end else begin : lower_group
                assign group_enable[g] = ~(|group_valid[7:g+1]);
            end
            assign group_winner[g] = group_valid[g] & group_enable[g];

            for (j = 0; j < 8; j = j + 1) begin : positions
                if (j == 7) begin : top_position
                    assign local_winner[g][j] = x[j];
                end else begin : lower_position
                    assign local_winner[g][j] = x[j] & ~(|x[7:j+1]);
                end
                if (g == 0 && j == 0) begin : default_position
                    assign output_unencoded[g*8+j] = ~(|input_unencoded[63:1]);
                end else begin : normal_position
                    assign output_unencoded[g*8+j] = local_winner[g][j] & group_enable[g];
                end
            end

            assign local_code[g][0] = |(local_winner[g] & 8'b10101010);
            assign local_code[g][1] = |(local_winner[g] & 8'b11001100);
            assign local_code[g][2] = |(local_winner[g] & 8'b11110000);
            for (b = 0; b < 3; b = b + 1) begin : code_gating
                assign code_terms[b][g] = local_code[g][b] & group_enable[g];
            end
        end

        assign output_valid = |group_valid;
        assign output_encoded[0] = |code_terms[0];
        assign output_encoded[1] = |code_terms[1];
        assign output_encoded[2] = |code_terms[2];
        assign output_encoded[3] = |(group_winner & 8'b10101010);
        assign output_encoded[4] = |(group_winner & 8'b11001100);
        assign output_encoded[5] = |(group_winner & 8'b11110000);
    end else begin : generic_encoder
        wire [W-1:0] input_padded;
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];
        assign input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
        genvar l, n;
        for (n = 0; n < W/2; n = n + 1) begin : loop_in
            assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : lsb_first
                assign stage_enc[0][n] = !input_padded[n*2];
            end else begin : msb_first
                assign stage_enc[0][n] = input_padded[n*2+1];
            end
        end
        for (l = 1; l < LEVELS; l = l + 1) begin : loop_levels
            for (n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
                assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin : lsb_first
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2] ? {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} : {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : msb_first
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
