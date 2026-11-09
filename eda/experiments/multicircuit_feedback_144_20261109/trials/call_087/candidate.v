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
        wire [3:0] local_code [15:0];

        for (genvar g = 0; g < 16; g = g + 1) begin : groups
            wire [15:0] x;
            assign x = input_unencoded[g*16 +: 16];
            assign group_valid[g] = |x;
            if (g == 15) begin : top_group
                assign group_enable[g] = 1'b1;
            end else begin : other_group
                assign group_enable[g] = ~(|group_valid[15:g+1]);
            end

            // Generate each local index bit directly from disjoint ranges.
            // No local index bit depends on another index bit.
            for (genvar b = 0; b < 4; b = b + 1) begin : local_bits
                localparam HALF = 2**b;
                localparam COUNT = 16/(2*HALF);
                wire [COUNT-1:0] terms;
                for (genvar t = 0; t < COUNT; t = t + 1) begin : ranges
                    localparam BASE = t*2*HALF;
                    if (BASE+2*HALF == 16) begin : highest
                        assign terms[t] = |x[BASE+HALF +: HALF];
                    end else begin : lower
                        assign terms[t] = (|x[BASE+HALF +: HALF]) &
                                          ~(|x[15:BASE+2*HALF]);
                    end
                end
                assign local_code[g][b] = |terms;
            end

            // Produce the one-hot result without decoding the binary index.
            for (genvar j = 0; j < 16; j = j + 1) begin : onehot
                if (g == 0 && j == 0) begin : default_bit
                    assign output_unencoded[0] = group_enable[0] & ~(|x[15:1]);
                end else if (j == 15) begin : highest_bit
                    assign output_unencoded[g*16+j] = group_enable[g] & x[j];
                end else begin : lower_bit
                    assign output_unencoded[g*16+j] = group_enable[g] & x[j] & ~(|x[15:j+1]);
                end
            end
        end

        assign output_valid = |group_valid;

        for (genvar b = 0; b < 4; b = b + 1) begin : low_index
            wire [15:0] terms;
            for (genvar g = 0; g < 16; g = g + 1) begin : select_group
                assign terms[g] = group_enable[g] & local_code[g][b];
            end
            assign output_encoded[b] = |terms;
        end

        for (genvar b = 0; b < 4; b = b + 1) begin : high_index
            localparam HALF = 2**b;
            localparam COUNT = 16/(2*HALF);
            wire [COUNT-1:0] terms;
            for (genvar t = 0; t < COUNT; t = t + 1) begin : ranges
                localparam BASE = t*2*HALF;
                if (BASE+2*HALF == 16) begin : highest
                    assign terms[t] = |group_valid[BASE+HALF +: HALF];
                end else begin : lower
                    assign terms[t] = (|group_valid[BASE+HALF +: HALF]) &
                                      ~(|group_valid[15:BASE+2*HALF]);
                end
            end
            assign output_encoded[b+4] = |terms;
        end
    end else begin : general_encoder
        wire [W-1:0] input_padded;
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];
        assign input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
        for (genvar n = 0; n < W/2; n = n + 1) begin : input_pairs
            assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : low_priority_select
                assign stage_enc[0][n] = !input_padded[n*2];
            end else begin : high_priority_select
                assign stage_enc[0][n] = input_padded[n*2+1];
            end
        end
        for (genvar l = 1; l < LEVELS; l = l + 1) begin : levels
            for (genvar n = 0; n < W/(2*2**l); n = n + 1) begin : nodes
                assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin : low_priority_select
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                        stage_valid[l-1][n*2] ?
                        {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                        {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : high_priority_select
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
