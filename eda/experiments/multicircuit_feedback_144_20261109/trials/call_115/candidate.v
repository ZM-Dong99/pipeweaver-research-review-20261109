`resetall
`timescale 1ns / 1ps
`default_nettype none

module priority_encoder_node #(
    parameter integer LEVEL = 1,
    parameter integer LSB_HIGH_PRIORITY = 0
) (
    input wire [(2**LEVEL)-1:0] input_bus,
    output wire valid,
    output wire [LEVEL-1:0] encoded,
    output wire [(2**LEVEL)-1:0] onehot
);
    localparam integer HALF = 2**(LEVEL-1);

    wire low_valid;
    wire high_valid;
    wire [LEVEL-2:0] low_encoded;
    wire [LEVEL-2:0] high_encoded;
    wire [HALF-1:0] low_onehot;
    wire [HALF-1:0] high_onehot;

    generate
        if (LEVEL == 1) begin : gen_leaf_children
            priority_encoder_leaf #(
                .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
            ) low_leaf (
                .input_bit(input_bus[0]),
                .valid(low_valid),
                .encoded(low_encoded[0]),
                .onehot(low_onehot[0])
            );
            priority_encoder_leaf #(
                .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
            ) high_leaf (
                .input_bit(input_bus[1]),
                .valid(high_valid),
                .encoded(high_encoded[0]),
                .onehot(high_onehot[0])
            );
        end else begin : gen_node_children
            priority_encoder_node #(
                .LEVEL(LEVEL-1),
                .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
            ) low_node (
                .input_bus(input_bus[HALF-1:0]),
                .valid(low_valid),
                .encoded(low_encoded),
                .onehot(low_onehot)
            );
            priority_encoder_node #(
                .LEVEL(LEVEL-1),
                .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
            ) high_node (
                .input_bus(input_bus[(2**LEVEL)-1:HALF]),
                .valid(high_valid),
                .encoded(high_encoded),
                .onehot(high_onehot)
            );
        end
    endgenerate

    assign valid = low_valid | high_valid;

    generate
        if (LSB_HIGH_PRIORITY) begin : gen_lsb_priority
            assign encoded = low_valid ? {1'b0, low_encoded} : {1'b1, high_encoded};
            assign onehot = low_valid ? {{HALF{1'b0}}, low_onehot} : {high_onehot, {HALF{1'b0}}};
        end else begin : gen_msb_priority
            assign encoded = high_valid ? {1'b1, high_encoded} : {1'b0, low_encoded};
            assign onehot = high_valid ? {high_onehot, {HALF{1'b0}}} : {{HALF{1'b0}}, low_onehot};
        end
    endgenerate
endmodule

module priority_encoder_leaf #(
    parameter integer LSB_HIGH_PRIORITY = 0
) (
    input wire input_bit,
    output wire valid,
    output wire encoded,
    output wire onehot
);
    assign valid = input_bit;
    assign encoded = 1'b0;
    assign onehot = input_bit;
endmodule

module priority_encoder #(
    parameter WIDTH = 4,
    parameter LSB_HIGH_PRIORITY = 0
) (
    input wire [WIDTH-1:0] input_unencoded,
    output wire output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0] output_unencoded
);
    parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1;
    parameter W = 2**LEVELS;

    wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
    wire [W-1:0] selected_onehot;

    priority_encoder_node #(
        .LEVEL(LEVELS),
        .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
    ) encoder_tree (
        .input_bus(input_padded),
        .valid(output_valid),
        .encoded(output_encoded),
        .onehot(selected_onehot)
    );

    assign output_unencoded[0] = selected_onehot[0] | ~output_valid;

    genvar k;
    generate
        for (k = 1; k < WIDTH; k = k + 1) begin : gen_output_bits
            assign output_unencoded[k] = selected_onehot[k];
        end
    endgenerate
endmodule

`resetall
