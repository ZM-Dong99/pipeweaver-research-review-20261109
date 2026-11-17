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
        wire [7:0] selected_code [2:0];

        genvar g, b, k;
        for (g = 0; g < 8; g = g + 1) begin : groups
            wire [7:0] x;
            wire [7:0] local_winner;
            wire [2:0] local_code;

            assign x = input_unencoded[8*g +: 8];
            assign group_valid[g] = |x;
            if (g == 7) begin : highest_group
                assign group_enable[g] = 1'b1;
            end else begin : other_group
                assign group_enable[g] = ~(|group_valid[7:g+1]);
            end
            assign group_winner[g] = group_valid[g] & group_enable[g];

            for (b = 0; b < 8; b = b + 1) begin : bits_in_group
                if (b == 7) begin : highest_bit
                    assign local_winner[b] = x[b];
                end else begin : other_bit
                    assign local_winner[b] = x[b] & ~(|x[7:b+1]);
                end

                if (g == 0 && b == 0) begin : default_bit
                    assign output_unencoded[0] = group_enable[0] & ~(|x[7:1]);
                end else begin : ordinary_bit
                    assign output_unencoded[8*g+b] = group_enable[g] & local_winner[b];
                end
            end

            assign local_code[0] = |(local_winner & 8'haa);
            assign local_code[1] = |(local_winner & 8'hcc);
            assign local_code[2] = |(local_winner & 8'hf0);
            for (k = 0; k < 3; k = k + 1) begin : code_terms
                assign selected_code[k][g] = group_enable[g] & local_code[k];
            end
        end

        assign output_valid = |group_valid;
        assign output_encoded[0] = |selected_code[0];
        assign output_encoded[1] = |selected_code[1];
        assign output_encoded[2] = |selected_code[2];
        assign output_encoded[3] = |(group_winner & 8'haa);
        assign output_encoded[4] = |(group_winner & 8'hcc);
        assign output_encoded[5] = |(group_winner & 8'hf0);
    end else begin : general_encoder
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
            for (n = 0; n < W/(2*2**l); n = n + 1) begin : compress
                assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin : lsb_merge
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                        stage_valid[l-1][n*2] ?
                        {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                        {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : msb_merge
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
