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
if (WIDTH == 256 && LSB_HIGH_PRIORITY == 0 && LEVELS == 8 && W == 256) begin : fast256
    wire [15:0] group_valid;
    wire [15:0] group_winner;
    wire [15:0] group_enable;
    wire [15:0] local_winner [0:15];
    wire [3:0] local_code [0:15];
    wire [15:0] low_terms [0:3];
    wire [15:0] high_terms [0:3];
    wire [255:0] selected;
    genvar g, j, b;
    for (g = 0; g < 16; g = g + 1) begin : groups
        assign group_valid[g] = |input_unencoded[g*16 +: 16];
        if (g == 15) begin : top_group
            assign group_enable[g] = 1'b1;
        end else begin : other_group
            assign group_enable[g] = ~(|group_valid[15:g+1]);
        end
        assign group_winner[g] = group_valid[g] & group_enable[g];
        for (j = 0; j < 16; j = j + 1) begin : positions
            if (j == 15) begin : top_position
                assign local_winner[g][j] = input_unencoded[g*16+j];
            end else begin : other_position
                assign local_winner[g][j] = input_unencoded[g*16+j] & ~(|input_unencoded[g*16+15:g*16+j+1]);
            end
            assign selected[g*16+j] = group_enable[g] & local_winner[g][j];
        end
        for (b = 0; b < 4; b = b + 1) begin : encode_local
            wire [15:0] terms;
            for (j = 0; j < 16; j = j + 1) begin : mask
                if ((j & (1 << b)) != 0) begin : include_bit
                    assign terms[j] = local_winner[g][j];
                end else begin : exclude_bit
                    assign terms[j] = 1'b0;
                end
            end
            assign local_code[g][b] = |terms;
            assign low_terms[b][g] = group_enable[g] & local_code[g][b];
            if ((g & (1 << b)) != 0) begin : include_group
                assign high_terms[b][g] = group_winner[g];
            end else begin : exclude_group
                assign high_terms[b][g] = 1'b0;
            end
        end
    end
    for (b = 0; b < 4; b = b + 1) begin : encode_global
        assign output_encoded[b] = |low_terms[b];
        assign output_encoded[b+4] = |high_terms[b];
    end
    assign output_valid = |group_valid;
    assign output_unencoded[255:1] = selected[255:1];
    assign output_unencoded[0] = ~(|input_unencoded[255:1]);
end else begin : generic_encoder
    wire [W-1:0] padded = {{W-WIDTH{1'b0}}, input_unencoded};
    reg [$clog2(WIDTH)-1:0] code;
    integer k;
    always @* begin
        if (LSB_HIGH_PRIORITY) begin
            code = W-1;
            for (k = W-1; k >= 0; k = k-1)
                if (padded[k]) code = k;
        end else begin
            code = 0;
            for (k = 0; k < W; k = k+1)
                if (padded[k]) code = k;
        end
    end
    assign output_valid = |padded;
    assign output_encoded = code;
    assign output_unencoded = 1 << output_encoded;
end
endgenerate
endmodule
`default_nettype wire
