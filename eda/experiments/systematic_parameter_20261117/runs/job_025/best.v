`timescale 1ns / 1ps
module priority_encoder #(
    parameter WIDTH = 4,
    parameter LSB_HIGH_PRIORITY = 0,
    parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1,
    parameter W = 2**LEVELS
)(
    input wire [WIDTH-1:0] input_unencoded,
    output wire output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0] output_unencoded
);

generate
if (WIDTH == 256 && !LSB_HIGH_PRIORITY && LEVELS == 8 && W == 256) begin : fast256
    wire [15:0] group_valid;
    wire [15:0] group_enable;
    wire [15:0] group_selected;
    wire [255:0] local_winner;
    wire [15:0] low_terms [3:0];
    wire [15:0] high_terms [3:0];
    genvar g, j, b;
    for (g = 0; g < 16; g = g + 1) begin : groups
        assign group_valid[g] = |input_unencoded[16*g +: 16];
        if (g == 15) begin : top_group
            assign group_enable[g] = 1'b1;
        end else begin : other_group
            assign group_enable[g] = ~(|group_valid[15:g+1]);
        end
        assign group_selected[g] = group_valid[g] & group_enable[g];
        for (j = 0; j < 16; j = j + 1) begin : positions
            if (j == 15) begin : top_position
                assign local_winner[16*g+j] = input_unencoded[16*g+j];
            end else begin : other_position
                assign local_winner[16*g+j] = input_unencoded[16*g+j] & ~(|input_unencoded[16*g+15:16*g+j+1]);
            end
            if (g == 0 && j == 0) begin : default_position
                assign output_unencoded[0] = (local_winner[0] & group_enable[0]) | ~output_valid;
            end else begin : normal_position
                assign output_unencoded[16*g+j] = local_winner[16*g+j] & group_enable[g];
            end
        end
        for (b = 0; b < 4; b = b + 1) begin : encode_local
            wire [15:0] masked;
            for (j = 0; j < 16; j = j + 1) begin : terms
                if ((j & (1 << b)) != 0) begin : included
                    assign masked[j] = local_winner[16*g+j];
                end else begin : excluded
                    assign masked[j] = 1'b0;
                end
            end
            assign low_terms[b][g] = (|masked) & group_enable[g];
            if ((g & (1 << b)) != 0) begin : included_group
                assign high_terms[b][g] = group_selected[g];
            end else begin : excluded_group
                assign high_terms[b][g] = 1'b0;
            end
        end
    end
    for (b = 0; b < 4; b = b + 1) begin : encode_output
        assign output_encoded[b] = |low_terms[b];
        assign output_encoded[b+4] = |high_terms[b];
    end
    assign output_valid = |group_valid;
end else begin : generic_tree
    wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W/2-1:0] stage_valid [LEVELS-1:0];
    wire [W/2-1:0] stage_enc [LEVELS-1:0];
    genvar l, n;
    for (n = 0; n < W/2; n = n + 1) begin : pairs
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin : lsb
            assign stage_enc[0][n] = !input_padded[n*2];
        end else begin : msb
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end
    for (l = 1; l < LEVELS; l = l + 1) begin : levels
        for (n = 0; n < W/(2*2**l); n = n + 1) begin : nodes
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
