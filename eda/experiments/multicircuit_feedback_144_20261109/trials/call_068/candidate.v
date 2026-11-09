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
    wire [15:0] group_winner;
    wire [255:0] winner;
    wire [3:0] local_code [0:15];
    wire [15:0] selected_code [0:3];

    for (genvar g = 0; g < 16; g = g + 1) begin : groups
        wire [15:0] x;
        assign x = input_unencoded[g*16 +: 16];
        assign group_valid[g] = |x;
        if (g == 15) begin : top_group
            assign group_enable[g] = 1'b1;
        end else begin : other_group
            assign group_enable[g] = ~(|group_valid[15:g+1]);
        end
        assign group_winner[g] = group_valid[g] & group_enable[g];

        for (genvar k = 0; k < 16; k = k + 1) begin : local_winners
            wire local_winner;
            if (k == 15) begin : top_bit
                assign local_winner = x[k];
            end else begin : other_bit
                assign local_winner = x[k] & ~(|x[15:k+1]);
            end
            assign winner[g*16+k] = local_winner & group_enable[g];
        end

        for (genvar b = 0; b < 4; b = b + 1) begin : local_encoding
            localparam HALF = 2**b;
            localparam TERMS = 16/(2*HALF);
            wire [TERMS-1:0] term;
            for (genvar t = 0; t < TERMS; t = t + 1) begin : runs
                localparam LO = (2*t+1)*HALF;
                localparam HI = (2*t+2)*HALF-1;
                if (HI == 15) begin : top_run
                    assign term[t] = |x[HI:LO];
                end else begin : other_run
                    assign term[t] = (|x[HI:LO]) & ~(|x[15:HI+1]);
                end
            end
            assign local_code[g][b] = |term;
            assign selected_code[b][g] = local_code[g][b] & group_enable[g];
        end
    end

    for (genvar b = 0; b < 4; b = b + 1) begin : encoding
        wire [15:0] upper_terms;
        for (genvar g = 0; g < 16; g = g + 1) begin : upper_bits
            if ((g & (2**b)) != 0) begin : included
                assign upper_terms[g] = group_winner[g];
            end else begin : excluded
                assign upper_terms[g] = 1'b0;
            end
        end
        assign output_encoded[b] = |selected_code[b];
        assign output_encoded[b+4] = |upper_terms;
    end

    assign output_valid = |group_valid;
    assign output_unencoded[255:1] = winner[255:1];
    assign output_unencoded[0] = winner[0] | ~output_valid;
end else begin : generic_encoder
    wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W/2-1:0] stage_valid [LEVELS-1:0];
    wire [W/2-1:0] stage_enc [LEVELS-1:0];

    for (genvar n = 0; n < W/2; n = n + 1) begin : loop_in
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin : low_priority_select
            assign stage_enc[0][n] = !input_padded[n*2];
        end else begin : high_priority_select
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end

    for (genvar l = 1; l < LEVELS; l = l + 1) begin : loop_levels
        for (genvar n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
            assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : low_priority_select
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2] ? {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} : {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
            end else begin : high_priority_select
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
