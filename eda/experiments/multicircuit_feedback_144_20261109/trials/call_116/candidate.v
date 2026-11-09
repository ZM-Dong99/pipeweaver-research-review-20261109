`resetall
`timescale 1ns / 1ps
`default_nettype none

module priority_tree #(
    parameter WIDTH = 2,
    parameter LSB_HIGH_PRIORITY = 0
) (
    input wire [WIDTH-1:0] input_unencoded,
    output wire output_valid,
    output wire [$clog2(WIDTH)-1:0] output_encoded,
    output wire [WIDTH-1:0] output_unencoded
);

generate
    if (WIDTH == 2) begin : gen_leaf
        if (LSB_HIGH_PRIORITY) begin : gen_lsb
            assign output_valid = |input_unencoded;
            assign output_encoded = ~input_unencoded[0];
            assign output_unencoded = input_unencoded[0] ? 2'b01 :
                                       input_unencoded[1] ? 2'b10 : 2'b00;
        end else begin : gen_msb
            assign output_valid = |input_unencoded;
            assign output_encoded = input_unencoded[1];
            assign output_unencoded = input_unencoded[1] ? 2'b10 :
                                       input_unencoded[0] ? 2'b01 : 2'b00;
        end
    end else begin : gen_node
        wire [WIDTH/2-1:0] low_unencoded;
        wire [WIDTH/2-1:0] high_unencoded;
        wire low_valid;
        wire high_valid;
        wire [$clog2(WIDTH/2)-1:0] low_encoded;
        wire [$clog2(WIDTH/2)-1:0] high_encoded;

        assign low_unencoded = input_unencoded[WIDTH/2-1:0];
        assign high_unencoded = input_unencoded[WIDTH-1:WIDTH/2];

        priority_tree #(
            .WIDTH(WIDTH/2),
            .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
        ) low_tree (
            .input_unencoded(low_unencoded),
            .output_valid(low_valid),
            .output_encoded(low_encoded),
            .output_unencoded()
        );

        priority_tree #(
            .WIDTH(WIDTH/2),
            .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
        ) high_tree (
            .input_unencoded(high_unencoded),
            .output_valid(high_valid),
            .output_encoded(high_encoded),
            .output_unencoded()
        );

        assign output_valid = low_valid | high_valid;

        if (LSB_HIGH_PRIORITY) begin : gen_lsb_node
            assign output_encoded = low_valid ? {1'b0, low_encoded} :
                                    {1'b1, high_encoded};
            assign output_unencoded = low_valid ?
                                      {{WIDTH/2{1'b0}}, low_unencoded} :
                                      {{WIDTH/2{1'b0}}, high_unencoded};
        end else begin : gen_msb_node
            assign output_encoded = high_valid ? {1'b1, high_encoded} :
                                     {1'b0, low_encoded};
            assign output_unencoded = high_valid ?
                                      {high_unencoded, {WIDTH/2{1'b0}}} :
                                      {low_unencoded, {WIDTH/2{1'b0}}};
        end
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

wire tree_valid;
wire [$clog2(WIDTH)-1:0] tree_encoded;
wire [WIDTH-1:0] tree_onehot;

priority_tree #(
    .WIDTH(WIDTH),
    .LSB_HIGH_PRIORITY(LSB_HIGH_PRIORITY)
) tree (
    .input_unencoded(input_unencoded),
    .output_valid(tree_valid),
    .output_encoded(tree_encoded),
    .output_unencoded(tree_onehot)
);

assign output_valid = tree_valid;
assign output_encoded = tree_encoded;
assign output_unencoded = tree_valid ? tree_onehot : {{WIDTH-1{1'b0}}, 1'b1};

endmodule

`resetall
