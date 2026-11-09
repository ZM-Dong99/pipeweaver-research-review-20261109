`resetall
`timescale 1ns / 1ps
`default_nettype none

module lfsr #(
    parameter LFSR_WIDTH = 31,
    parameter LFSR_POLY = 31'h10000001,
    parameter LFSR_CONFIG = "FIBONACCI",
    parameter LFSR_FEED_FORWARD = 0,
    parameter REVERSE = 0,
    parameter DATA_WIDTH = 8,
    parameter STYLE = "AUTO"
)(
    input wire [DATA_WIDTH-1:0] data_in,
    input wire [LFSR_WIDTH-1:0] state_in,
    output wire [DATA_WIDTH-1:0] data_out,
    output wire [LFSR_WIDTH-1:0] state_out
);

    wire [LFSR_WIDTH-1:0] stage [0:DATA_WIDTH];
    wire feedback [0:DATA_WIDTH-1];

    assign stage[0] = state_in;

    genvar k;
    genvar j;
    generate
        for (k = 0; k < DATA_WIDTH; k = k + 1) begin : gen_step
            assign feedback[k] = stage[k][LFSR_WIDTH-1] ^
                                 (REVERSE ? data_in[DATA_WIDTH-1-k] : data_in[k]);
            assign stage[k+1][0] = feedback[k];
            for (j = 1; j < LFSR_WIDTH; j = j + 1) begin : gen_bit
                if ((LFSR_POLY >> j) & 1) begin : gen_tap
                    assign stage[k+1][j] = stage[k][j-1] ^ feedback[k];
                end else begin : gen_no_tap
                    assign stage[k+1][j] = stage[k][j-1];
                end
            end
        end
    endgenerate

    assign state_out = stage[DATA_WIDTH];

    generate
        for (k = 0; k < DATA_WIDTH; k = k + 1) begin : gen_data_out
            if (REVERSE) begin : gen_reversed
                assign data_out[k] = feedback[DATA_WIDTH-1-k];
            end else begin : gen_native
                assign data_out[k] = feedback[k];
            end
        end
    endgenerate
endmodule

`resetall

module crc32_d8(
    input wire [7:0] data_in,
    input wire [31:0] state_in,
    output wire [7:0] data_out,
    output wire [31:0] state_out
);
    lfsr #(
        .LFSR_WIDTH(32),
        .LFSR_POLY(32'h04c11db7),
        .LFSR_CONFIG("GALOIS"),
        .LFSR_FEED_FORWARD(0),
        .REVERSE(1),
        .DATA_WIDTH(8),
        .STYLE("REDUCTION")
    ) core (
        .data_in(data_in),
        .state_in(state_in),
        .data_out(data_out),
        .state_out(state_out)
    );
endmodule
