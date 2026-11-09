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
        wire [15:0] group_select;
        wire [3:0] group_code;
        wire [3:0] local_code [0:15];
        wire [15:0] local_onehot [0:15];
        wire [15:0] selected_code [0:3];

        for (genvar g = 0; g < 16; g = g + 1) begin : groups
            wire [15:0] x;
            assign x = input_unencoded[g*16 +: 16];
            assign group_valid[g] = |x;

            if (g == 0) begin : first_group
                assign group_select[g] = ~(|group_valid[15:1]);
            end else if (g == 15) begin : last_group
                assign group_select[g] = group_valid[g];
            end else begin : middle_group
                assign group_select[g] = group_valid[g] & ~(|group_valid[15:g+1]);
            end

            for (genvar j = 0; j < 16; j = j + 1) begin : local_decode
                if (j == 0) begin : default_bit
                    assign local_onehot[g][j] = ~(|x[15:1]);
                end else if (j == 15) begin : top_bit
                    assign local_onehot[g][j] = x[j];
                end else begin : middle_bit
                    assign local_onehot[g][j] = x[j] & ~(|x[15:j+1]);
                end
                assign output_unencoded[g*16+j] = group_select[g] & local_onehot[g][j];
            end

            for (genvar b = 0; b < 4; b = b + 1) begin : local_encode
                localparam S = 2**b;
                localparam T = 16/(2*S);
                wire [T-1:0] terms;
                for (genvar t = 0; t < T; t = t + 1) begin : intervals
                    if ((t+1)*2*S == 16) begin : highest_interval
                        assign terms[t] = |x[(t+1)*2*S-1:(2*t+1)*S];
                    end else begin : other_interval
                        assign terms[t] = (|x[(t+1)*2*S-1:(2*t+1)*S]) & ~(|x[15:(t+1)*2*S]);
                    end
                end
                assign local_code[g][b] = |terms;
                assign selected_code[b][g] = group_select[g] & local_code[g][b];
            end
        end

        for (genvar b = 0; b < 4; b = b + 1) begin : global_encode
            localparam S = 2**b;
            localparam T = 16/(2*S);
            wire [T-1:0] terms;
            for (genvar t = 0; t < T; t = t + 1) begin : intervals
                if ((t+1)*2*S == 16) begin : highest_interval
                    assign terms[t] = |group_valid[(t+1)*2*S-1:(2*t+1)*S];
                end else begin : other_interval
                    assign terms[t] = (|group_valid[(t+1)*2*S-1:(2*t+1)*S]) & ~(|group_valid[15:(t+1)*2*S]);
                end
            end
            assign group_code[b] = |terms;
            assign output_encoded[b+4] = group_code[b];
            assign output_encoded[b] = |selected_code[b];
        end
        assign output_valid = |group_valid;
    end else begin : original_parameters
        wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];

        for (genvar n = 0; n < W/2; n = n + 1) begin : loop_in
            assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : lsb
                assign stage_enc[0][n] = !input_padded[n*2];
            end else begin : msb
                assign stage_enc[0][n] = input_padded[n*2+1];
            end
        end
        for (genvar l = 1; l < LEVELS; l = l + 1) begin : loop_levels
            for (genvar n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
                assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin : lsb
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2] ? {1'b0, stage_enc[l-1][(n*2+1)*l-1:n*2*l]} : {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : msb
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2+1] ? {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]} : {1'b0, stage_enc[l-1][(n*2+1)*l-1:n*2*l]};
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
