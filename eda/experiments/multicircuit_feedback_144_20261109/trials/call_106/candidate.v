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
    if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast_256
        wire [15:0] group_valid;
        wire [15:0] group_enable;
        wire [15:0] group_selected;
        wire [15:0] code_bit0;
        wire [15:0] code_bit1;
        wire [15:0] code_bit2;
        wire [15:0] code_bit3;
        genvar g, j;
        for (g = 0; g < 16; g = g + 1) begin : groups
            wire [15:0] x;
            wire [15:0] local_hot;
            wire [3:0] local_code;
            assign x = input_unencoded[16*g +: 16];
            assign group_valid[g] = |x;
            if (g == 15) begin : highest_group
                assign group_enable[g] = 1'b1;
            end else begin : lower_group
                assign group_enable[g] = ~(|group_valid[15:g+1]);
            end
            assign group_selected[g] = group_enable[g] & group_valid[g];
            assign local_hot[0] = 1'b0;
            for (j = 1; j < 16; j = j + 1) begin : local_priority
                if (j == 15) begin : highest_bit
                    assign local_hot[j] = x[j];
                end else begin : lower_bit
                    assign local_hot[j] = x[j] & ~(|x[15:j+1]);
                end
                assign output_unencoded[16*g+j] = group_enable[g] & local_hot[j];
            end
            if (g == 0) begin : default_bit
                assign output_unencoded[0] = group_enable[0] & ~(|x[15:1]);
            end else begin : ordinary_bit_zero
                assign output_unencoded[16*g] = group_enable[g] & x[0] & ~(|x[15:1]);
            end
            assign local_code[0] = |(local_hot & 16'haaaa);
            assign local_code[1] = |(local_hot & 16'hcccc);
            assign local_code[2] = |(local_hot & 16'hf0f0);
            assign local_code[3] = |(local_hot & 16'hff00);
            assign code_bit0[g] = group_enable[g] & local_code[0];
            assign code_bit1[g] = group_enable[g] & local_code[1];
            assign code_bit2[g] = group_enable[g] & local_code[2];
            assign code_bit3[g] = group_enable[g] & local_code[3];
        end
        assign output_valid = |group_valid;
        assign output_encoded[0] = |code_bit0;
        assign output_encoded[1] = |code_bit1;
        assign output_encoded[2] = |code_bit2;
        assign output_encoded[3] = |code_bit3;
        assign output_encoded[4] = |(group_selected & 16'haaaa);
        assign output_encoded[5] = |(group_selected & 16'hcccc);
        assign output_encoded[6] = |(group_selected & 16'hf0f0);
        assign output_encoded[7] = |(group_selected & 16'hff00);
    end else begin : general_encoder
        wire [W-1:0] input_padded;
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];
        assign input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
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
