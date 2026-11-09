`resetall
`timescale 1ns / 1ps
`default_nettype none

module priority_encoder #
(
    parameter WIDTH = 4,
    parameter LSB_HIGH_PRIORITY = 0
)
(
    input  wire [WIDTH-1:0]         input_unencoded,
    output wire                     output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0]         output_unencoded
);

parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1;
parameter W = 2**LEVELS;

wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};

wire [W/2-1:0] stage_valid[LEVELS-1:0];
wire [W/2-1:0] stage_enc[LEVELS-1:0];

wire [WIDTH-1:0] scan[0:LEVELS];
assign scan[0] = input_unencoded;

generate
    genvar l, n, s, i;

    for (n = 0; n < W/2; n = n + 1) begin : loop_in
        assign stage_valid[0][n] = |input_padded[n*2+1:n*2];
        if (LSB_HIGH_PRIORITY) begin
            assign stage_enc[0][n] = !input_padded[n*2+0];
        end else begin
            assign stage_enc[0][n] = input_padded[n*2+1];
        end
    end

    for (l = 1; l < LEVELS; l = l + 1) begin : loop_levels
        for (n = 0; n < W/(2*2**l); n = n + 1) begin : loop_compress
            assign stage_valid[l][n] = |stage_valid[l-1][n*2+1:n*2];
            if (LSB_HIGH_PRIORITY) begin
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2+0] ? {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2+0)*l]} : {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]};
            end else begin
                assign stage_enc[l][(n+1)*(l+1)-1:n*(l+1)] = stage_valid[l-1][n*2+1] ? {1'b1, stage_enc[l-1][(n*2+2)*l-1:(n*2+1)*l]} : {1'b0, stage_enc[l-1][(n*2+1)*l-1:(n*2+0)*l]};
            end
        end
    end

    assign output_encoded = stage_enc[LEVELS-1];

    if (LSB_HIGH_PRIORITY) begin : gen_lsb_priority
        for (s = 0; s < LEVELS; s = s + 1) begin : scan_level
            for (i = 0; i < WIDTH; i = i + 1) begin : scan_bit
                if (i >= (1 << s)) begin
                    assign scan[s+1][i] = scan[s][i] | scan[s][i-(1 << s)];
                end else begin
                    assign scan[s+1][i] = scan[s][i];
                end
            end
        end
        assign output_valid = scan[LEVELS][WIDTH-1];
        for (i = 0; i < WIDTH; i = i + 1) begin : encode_onehot
            if (i == 0) begin
                assign output_unencoded[i] = input_unencoded[i] | ~output_valid;
            end else begin
                assign output_unencoded[i] = input_unencoded[i] & ~scan[LEVELS][i-1];
            end
        end
    end else begin : gen_msb_priority
        for (s = 0; s < LEVELS; s = s + 1) begin : scan_level
            for (i = 0; i < WIDTH; i = i + 1) begin : scan_bit
                if (i + (1 << s) < WIDTH) begin
                    assign scan[s+1][i] = scan[s][i] | scan[s][i+(1 << s)];
                end else begin
                    assign scan[s+1][i] = scan[s][i];
                end
            end
        end
        assign output_valid = scan[LEVELS][0];
        for (i = 0; i < WIDTH; i = i + 1) begin : encode_onehot
            if (i == 0) begin
                assign output_unencoded[i] = (input_unencoded[i] & ~scan[LEVELS][i+1]) | ~output_valid;
            end else if (i == WIDTH-1) begin
                assign output_unencoded[i] = input_unencoded[i];
            end else begin
                assign output_unencoded[i] = input_unencoded[i] & ~scan[LEVELS][i+1];
            end
        end
    end
endgenerate

endmodule

`resetall
