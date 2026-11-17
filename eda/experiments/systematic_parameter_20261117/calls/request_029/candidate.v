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
        wire [15:0] group_winner;
        wire [15:0] local_winner [0:15];
        wire [3:0] local_encoded [0:15];
        wire [15:0] low_terms [0:3];
        wire [15:0] high_terms [0:3];

        genvar g, i, b;
        for (g = 0; g < 16; g = g + 1) begin : groups
            assign group_valid[g] = |input_unencoded[g*16 +: 16];
            if (g == 15) begin : top_group
                assign group_enable[g] = 1'b1;
            end else begin : other_group
                assign group_enable[g] = ~(|group_valid[15:g+1]);
            end
            assign group_winner[g] = group_valid[g] & group_enable[g];

            for (i = 0; i < 16; i = i + 1) begin : positions
                if (i == 15) begin : top_position
                    assign local_winner[g][i] = input_unencoded[g*16+i];
                end else begin : other_position
                    assign local_winner[g][i] = input_unencoded[g*16+i] &
                        ~(|input_unencoded[g*16+15:g*16+i+1]);
                end
                if (g == 0 && i == 0) begin : default_position
                    // The reference decodes index zero even when no input is set.
                    assign output_unencoded[g*16+i] = group_enable[g] &
                        ~(|input_unencoded[15:1]);
                end else begin : normal_position
                    assign output_unencoded[g*16+i] = group_enable[g] & local_winner[g][i];
                end
            end

            for (b = 0; b < 4; b = b + 1) begin : encode_local
                wire [15:0] terms;
                for (i = 0; i < 16; i = i + 1) begin : encode_positions
                    if ((i >> b) & 1) begin : included
                        assign terms[i] = local_winner[g][i];
                    end else begin : excluded
                        assign terms[i] = 1'b0;
                    end
                end
                assign local_encoded[g][b] = |terms;
                assign low_terms[b][g] = group_enable[g] & local_encoded[g][b];
                if ((g >> b) & 1) begin : included_group
                    assign high_terms[b][g] = group_winner[g];
                end else begin : excluded_group
                    assign high_terms[b][g] = 1'b0;
                end
            end
        end

        for (b = 0; b < 4; b = b + 1) begin : final_encode
            assign output_encoded[b] = |low_terms[b];
            assign output_encoded[b+4] = |high_terms[b];
        end
        assign output_valid = |group_valid;
    end else begin : generic_encoder
        wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];
        genvar l, n;

        for (n = 0; n < W/2; n = n + 1) begin : loop_in
            assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : lsb_input
                assign stage_enc[0][n] = !input_padded[n*2];
            end else begin : msb_input
                assign stage_enc[0][n] = input_padded[n*2+1];
            end
        end

        for (l = 1; l < LEVELS; l = l + 1) begin : loop_levels
            for (n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
                assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin : lsb_compress
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                        stage_valid[l-1][n*2] ?
                        {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                        {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : msb_compress
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
