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
        wire [255:0] local_winner;
        wire [15:0] low_terms [3:0];
        genvar g, j, b;

        for (g = 0; g < 16; g = g + 1) begin : groups
            assign group_valid[g] = |input_unencoded[g*16 +: 16];
            if (g == 15) begin : highest_group
                assign group_enable[g] = 1'b1;
            end else begin : lower_group
                assign group_enable[g] = ~(|group_valid[15:g+1]);
            end
            assign group_winner[g] = group_valid[g] & group_enable[g];

            for (j = 0; j < 16; j = j + 1) begin : positions
                if (j == 15) begin : highest_local
                    assign local_winner[g*16+j] = input_unencoded[g*16+j];
                end else begin : lower_local
                    assign local_winner[g*16+j] = input_unencoded[g*16+j] &
                        ~(|input_unencoded[g*16+15:g*16+j+1]);
                end
                if (g == 0 && j == 0) begin : default_position
                    assign output_unencoded[0] = ~(|input_unencoded[255:1]);
                end else begin : selected_position
                    assign output_unencoded[g*16+j] =
                        local_winner[g*16+j] & group_enable[g];
                end
            end

            for (b = 0; b < 4; b = b + 1) begin : local_encode
                localparam [15:0] MASK = b == 0 ? 16'hAAAA :
                                            b == 1 ? 16'hCCCC :
                                            b == 2 ? 16'hF0F0 : 16'hFF00;
                assign low_terms[b][g] = group_enable[g] &
                    (|(local_winner[g*16 +: 16] & MASK));
            end
        end

        for (b = 0; b < 4; b = b + 1) begin : encode_outputs
            localparam [15:0] MASK = b == 0 ? 16'hAAAA :
                                        b == 1 ? 16'hCCCC :
                                        b == 2 ? 16'hF0F0 : 16'hFF00;
            assign output_encoded[b] = |low_terms[b];
            assign output_encoded[b+4] = |(group_winner & MASK);
        end
        assign output_valid = |group_valid;
    end else begin : original_parameter_behavior
        wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
        wire [W/2-1:0] stage_valid [LEVELS-1:0];
        wire [W/2-1:0] stage_enc [LEVELS-1:0];
        genvar l, n;
        for (n = 0; n < W/2; n = n + 1) begin : loop_in
            assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin : low_first
                assign stage_enc[0][n] = !input_padded[n*2];
            end else begin : high_first
                assign stage_enc[0][n] = input_padded[n*2+1];
            end
        end
        for (l = 1; l < LEVELS; l = l + 1) begin : loop_levels
            for (n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
                assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
                if (LSB_HIGH_PRIORITY) begin : low_first
                    assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] =
                        stage_valid[l-1][n*2] ?
                        {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2)*l]} :
                        {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
                end else begin : high_first
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
