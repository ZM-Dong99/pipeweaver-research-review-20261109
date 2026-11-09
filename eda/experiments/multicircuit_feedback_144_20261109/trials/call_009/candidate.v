`resetall
`timescale 1ns / 1ps
`default_nettype none

module priority_encoder_16
(
    input  wire [15:0] input_unencoded,
    output wire        output_valid,
    output wire [3:0]  output_encoded,
    output wire [15:0] output_unencoded
);

wire [7:0] stage_valid0;
wire [3:0] stage_valid1;
wire [1:0] stage_valid2;
wire       stage_valid3;
wire [7:0] stage_enc0;
wire [7:0] stage_enc1;
wire [7:0] stage_enc2;
wire [7:0] stage_enc3;

assign stage_valid0[0] = |input_unencoded[1:0];
assign stage_valid0[1] = |input_unencoded[3:2];
assign stage_valid0[2] = |input_unencoded[5:4];
assign stage_valid0[3] = |input_unencoded[7:6];
assign stage_valid0[4] = |input_unencoded[9:8];
assign stage_valid0[5] = |input_unencoded[11:10];
assign stage_valid0[6] = |input_unencoded[13:12];
assign stage_valid0[7] = |input_unencoded[15:14];

assign stage_enc0[0] = input_unencoded[1];
assign stage_enc0[1] = input_unencoded[3];
assign stage_enc0[2] = input_unencoded[5];
assign stage_enc0[3] = input_unencoded[7];
assign stage_enc0[4] = input_unencoded[9];
assign stage_enc0[5] = input_unencoded[11];
assign stage_enc0[6] = input_unencoded[13];
assign stage_enc0[7] = input_unencoded[15];

assign stage_valid1[0] = stage_valid0[1] | stage_valid0[0];
assign stage_valid1[1] = stage_valid0[3] | stage_valid0[2];
assign stage_valid1[2] = stage_valid0[5] | stage_valid0[4];
assign stage_valid1[3] = stage_valid0[7] | stage_valid0[6];

assign stage_enc1[1:0] = stage_valid0[1] ? {1'b1,stage_enc0[1]} : {1'b0,stage_enc0[0]};
assign stage_enc1[3:2] = stage_valid0[3] ? {1'b1,stage_enc0[3]} : {1'b0,stage_enc0[2]};
assign stage_enc1[5:4] = stage_valid0[5] ? {1'b1,stage_enc0[5]} : {1'b0,stage_enc0[4]};
assign stage_enc1[7:6] = stage_valid0[7] ? {1'b1,stage_enc0[7]} : {1'b0,stage_enc0[6]};

assign stage_valid2[0] = stage_valid1[1] | stage_valid1[0];
assign stage_valid2[1] = stage_valid1[3] | stage_valid1[2];

assign stage_enc2[2:0] = stage_valid1[1] ? {1'b1,stage_enc1[3:2]} : {1'b0,stage_enc1[1:0]};
assign stage_enc2[5:3] = stage_valid1[3] ? {1'b1,stage_enc1[7:6]} : {1'b0,stage_enc1[5:4]};

assign stage_valid3 = stage_valid2[1] | stage_valid2[0];
assign stage_enc3[3:0] = stage_valid2[1] ? {1'b1,stage_enc2[5:3]} : {1'b0,stage_enc2[2:0]};

assign output_valid = stage_valid3;
assign output_encoded = stage_enc3[3:0];
assign output_unencoded = output_valid ? (16'b1 << output_encoded) : 16'b0;

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

wire [15:0] group_valid;
wire [15:0] group_encoded_onehot;
wire       group_output_valid;
wire [3:0] group_encoded;
wire [3:0] local_encoded [0:15];
wire [15:0] local_valid;
wire [15:0] local_unencoded [0:15];
wire [255:0] selected_unencoded;

genvar g;
generate
    for (g = 0; g < 16; g = g + 1) begin : gen_local
        priority_encoder_16 local_encoder (
            .input_unencoded(input_unencoded[g*16 +: 16]),
            .output_valid(local_valid[g]),
            .output_encoded(local_encoded[g]),
            .output_unencoded(local_unencoded[g])
        );
        assign group_valid[g] = local_valid[g];
    end
endgenerate

priority_encoder_16 group_encoder (
    .input_unencoded(group_valid),
    .output_valid(group_output_valid),
    .output_encoded(group_encoded),
    .output_unencoded(group_encoded_onehot)
);

generate
    for (g = 0; g < 16; g = g + 1) begin : gen_selected
        assign selected_unencoded[g*16 +: 16] = local_unencoded[g] & {16{group_encoded_onehot[g]}};
    end
endgenerate

assign output_valid = group_output_valid;
assign output_encoded = {group_encoded, local_encoded[group_encoded]};
assign output_unencoded = selected_unencoded | {{255{1'b0}}, ~group_output_valid};

endmodule

`resetall
