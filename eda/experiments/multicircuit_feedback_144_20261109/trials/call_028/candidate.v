`resetall
`timescale 1ns / 1ps
`default_nettype none

module priority_encoder_tree #(
    parameter N = 2,
    parameter LSB_HIGH_PRIORITY = 0
) (
    input  wire [N-1:0] input_data,
    output wire         output_valid,
    output wire [$clog2(N)-1:0] output_encoded
);
    generate
        if (N == 2) begin : gen_leaf
            assign output_valid = |input_data;
            if (LSB_HIGH_PRIORITY) begin : gen_lsb
                assign output_encoded = input_data[0] ? 1'b0 : 1'b1;
            end else begin : gen_msb
                assign output_encoded = input_data[1] ? 1'b1 : 1'b0;
            end
        end else begin : gen_node
            wire low_valid;
            wire high_valid;
            wire [$clog2(N/2)-1:0] low_encoded;
            wire [$clog2(N/2)-1:0] high_encoded;

            priority_encoder_tree #(
                .N(N/2),
                .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
            ) low_tree (
                .input_data(input_data[N/2-1:0]),
                .output_valid(low_valid),
                .output_encoded(low_encoded)
            );

            priority_encoder_tree #(
                .N(N/2),
                .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
            ) high_tree (
                .input_data(input_data[N-1:N/2]),
                .output_valid(high_valid),
                .output_encoded(high_encoded)
            );

            assign output_valid = low_valid | high_valid;
            if (LSB_HIGH_PRIORITY) begin : gen_lsb
                assign output_encoded = low_valid ?
                    {1'b0, low_encoded} : {1'b1, high_encoded};
            end else begin : gen_msb
                assign output_encoded = high_valid ?
                    {1'b1, high_encoded} : {1'b0, low_encoded};
            end
        end
    endgenerate
endmodule

module priority_encoder #(
    parameter WIDTH = 4,
    parameter LSB_HIGH_PRIORITY = 0
) (
    input  wire [WIDTH-1:0] input_unencoded,
    output wire             output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0] output_unencoded
);
    parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1;
    parameter W = 2**LEVELS;

    wire [W-1:0] input_padded;
    wire [LEVELS-1:0] encoded_int;

    assign input_padded = {{W-WIDTH{1'b0}}, input_unencoded};

    priority_encoder_tree #(
        .N(W),
        .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
    ) encoder_tree (
        .input_data(input_padded),
        .output_valid(output_valid),
        .output_encoded(encoded_int)
    );

    assign output_encoded = encoded_int;
    assign output_unencoded = 1 << output_encoded;
endmodule

`resetall
