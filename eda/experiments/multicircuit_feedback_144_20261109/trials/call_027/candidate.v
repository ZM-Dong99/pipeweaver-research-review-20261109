`resetall
`timescale 1ns / 1ps
`default_nettype none

module priority_tree #(
    parameter N = 2,
    parameter LSB_HIGH_PRIORITY = 0
) (
    input  wire [N-1:0] input_data,
    output wire         output_valid,
    output wire [$clog2(N)-1:0] output_encoded,
    output wire [N-1:0] output_onehot
);

localparam LEVELS = $clog2(N);

generate
    if (N == 2) begin : gen_leaf
        if (LSB_HIGH_PRIORITY) begin : gen_lsb
            assign output_valid = |input_data;
            assign output_encoded = input_data[0] ? 1'b0 : 1'b1;
            assign output_onehot[0] = input_data[0];
            assign output_onehot[1] = ~input_data[0] & input_data[1];
        end else begin : gen_msb
            assign output_valid = |input_data;
            assign output_encoded = input_data[1];
            assign output_onehot[1] = input_data[1];
            assign output_onehot[0] = ~input_data[1] & input_data[0];
        end
    end else begin : gen_node
        wire child_low_valid;
        wire child_high_valid;
        wire [LEVELS-2:0] child_low_encoded;
        wire [LEVELS-2:0] child_high_encoded;
        wire [N/2-1:0] child_low_onehot;
        wire [N/2-1:0] child_high_onehot;

        priority_tree #(
            .N(N/2),
            .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
        ) child_low (
            .input_data(input_data[N/2-1:0]),
            .output_valid(child_low_valid),
            .output_encoded(child_low_encoded),
            .output_onehot(child_low_onehot)
        );

        priority_tree #(
            .N(N/2),
            .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
        ) child_high (
            .input_data(input_data[N-1:N/2]),
            .output_valid(child_high_valid),
            .output_encoded(child_high_encoded),
            .output_onehot(child_high_onehot)
        );

        if (LSB_HIGH_PRIORITY) begin : gen_lsb_node
            assign output_valid = child_low_valid | child_high_valid;
            assign output_encoded = child_low_valid ?
                {1'b0, child_low_encoded} : {1'b1, child_high_encoded};
            assign output_onehot[N/2-1:0] = child_low_valid ?
                child_low_onehot : {N/2{1'b0}};
            assign output_onehot[N-1:N/2] = child_low_valid ?
                {N/2{1'b0}} : child_high_onehot;
        end else begin : gen_msb_node
            assign output_valid = child_low_valid | child_high_valid;
            assign output_encoded = child_high_valid ?
                {1'b1, child_high_encoded} : {1'b0, child_low_encoded};
            assign output_onehot[N/2-1:0] = child_high_valid ?
                {N/2{1'b0}} : child_low_onehot;
            assign output_onehot[N-1:N/2] = child_high_valid ?
                child_high_onehot : {N/2{1'b0}};
        end
    end
endgenerate

endmodule

module priority_encoder #(
    parameter WIDTH = 4,
    parameter LSB_HIGH_PRIORITY = 0
) (
    input  wire [WIDTH-1:0]         input_unencoded,
    output wire                     output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0]         output_unencoded
);

parameter LEVELS = WIDTH > 2 ? $clog2(WIDTH) : 1;
parameter W = 2**LEVELS;

wire [W-1:0] input_padded = {{W-WIDTH{1'b0}}, input_unencoded};
wire tree_valid;
wire [LEVELS-1:0] tree_encoded;
wire [W-1:0] tree_onehot;

priority_tree #(
    .N(W),
    .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
) encoder_tree (
    .input_data(input_padded),
    .output_valid(tree_valid),
    .output_encoded(tree_encoded),
    .output_onehot(tree_onehot)
);

assign output_valid = tree_valid;
assign output_encoded = tree_encoded;

generate
    if (LSB_HIGH_PRIORITY) begin : gen_original_shift
        assign output_unencoded = 1 << output_encoded;
    end else begin : gen_direct_onehot
        assign output_unencoded = tree_onehot[WIDTH-1:0] |
            {{WIDTH-1{1'b0}}, ~output_valid};
    end
endgenerate

endmodule

`resetall
