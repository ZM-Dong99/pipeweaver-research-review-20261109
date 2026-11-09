`resetall
`timescale 1ns / 1ps
`default_nettype none

module priority_encoder_tree #(
    parameter WIDTH = 2,
    parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1
) (
    input  wire [WIDTH-1:0] input_unencoded,
    output wire             output_valid,
    output wire [LEVELS-1:0] output_encoded,
    output wire [WIDTH-1:0] output_unencoded
);

localparam HALF = WIDTH / 2;

generate
    if (WIDTH == 2) begin : gen_leaf
        assign output_valid = |input_unencoded;
        assign output_encoded = input_unencoded[1];
        assign output_unencoded = input_unencoded[1] ? 2'b10 : 2'b01;
    end else begin : gen_node
        wire left_valid;
        wire right_valid;
        wire [LEVELS-2:0] left_encoded;
        wire [LEVELS-2:0] right_encoded;
        wire [HALF-1:0] left_unencoded;
        wire [HALF-1:0] right_unencoded;

        priority_encoder_tree #(
            .WIDTH(HALF),
            .LEVELS(LEVELS-1)
        ) left_tree (
            .input_unencoded(input_unencoded[HALF-1:0]),
            .output_valid(left_valid),
            .output_encoded(left_encoded),
            .output_unencoded(left_unencoded)
        );

        priority_encoder_tree #(
            .WIDTH(HALF),
            .LEVELS(LEVELS-1)
        ) right_tree (
            .input_unencoded(input_unencoded[WIDTH-1:HALF]),
            .output_valid(right_valid),
            .output_encoded(right_encoded),
            .output_unencoded(right_unencoded)
        );

        assign output_valid = left_valid | right_valid;
        assign output_encoded = right_valid ? {1'b1, right_encoded} : {1'b0, left_encoded};
        assign output_unencoded = right_valid ? {right_unencoded, {HALF{1'b0}}} : {{HALF{1'b0}}, left_unencoded};
    end
endgenerate

endmodule

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

priority_encoder_tree #(
    .WIDTH(WIDTH),
    .LEVELS(LEVELS)
) encoder_tree (
    .input_unencoded(input_unencoded),
    .output_valid(output_valid),
    .output_encoded(output_encoded),
    .output_unencoded(output_unencoded)
);

endmodule

`resetall
