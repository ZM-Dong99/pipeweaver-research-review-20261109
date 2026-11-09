`resetall
`timescale 1ns / 1ps
`default_nettype none

module crc32_fixed (
    input wire [7:0] data_in,
    input wire [31:0] state_in,
    output wire [7:0] data_out,
    output wire [31:0] state_out
);

function [39:0] crc_mask;
    input integer index;
    reg [31:0] state_mask [0:31];
    reg [7:0] data_mask [0:31];
    reg [31:0] output_state_mask [0:7];
    reg [7:0] output_data_mask [0:7];
    reg [31:0] state_value;
    reg [7:0] data_value;
    reg [7:0] bit_mask;
    reg [31:0] selected_state;
    reg [7:0] selected_data;
    integer i;
    integer j;
    begin
        for (i = 0; i < 32; i = i + 1) begin
            state_mask[i] = 32'b0;
            state_mask[i][i] = 1'b1;
            data_mask[i] = 8'b0;
        end
        for (i = 0; i < 8; i = i + 1) begin
            output_state_mask[i] = 32'b0;
            output_data_mask[i] = 8'b0;
        end

        bit_mask = 8'b10000000;
        for (i = 0; i < 8; i = i + 1) begin
            state_value = state_mask[31];
            data_value = data_mask[31] ^ bit_mask;

            for (j = 31; j > 0; j = j - 1) begin
                state_mask[j] = state_mask[j-1];
                data_mask[j] = data_mask[j-1];
            end
            for (j = 7; j > 0; j = j - 1) begin
                output_state_mask[j] = output_state_mask[j-1];
                output_data_mask[j] = output_data_mask[j-1];
            end
            output_state_mask[0] = state_value;
            output_data_mask[0] = data_value;

            state_mask[0] = state_value;
            data_mask[0] = data_value;
            for (j = 1; j < 32; j = j + 1) begin
                if ((32'h04c11db7 >> j) & 1'b1) begin
                    state_mask[j] = state_mask[j] ^ state_value;
                    data_mask[j] = data_mask[j] ^ data_value;
                end
            end
            bit_mask = bit_mask >> 1;
        end

        selected_state = 32'b0;
        selected_data = 8'b0;
        if (index < 32) begin
            for (i = 0; i < 32; i = i + 1)
                selected_state[i] = state_mask[31-index][31-i];
            for (i = 0; i < 8; i = i + 1)
                selected_data[i] = data_mask[31-index][7-i];
        end else begin
            for (i = 0; i < 32; i = i + 1)
                selected_state[i] = output_state_mask[7-(index-32)][31-i];
            for (i = 0; i < 8; i = i + 1)
                selected_data[i] = output_data_mask[7-(index-32)][7-i];
        end
        crc_mask = {selected_data, selected_state};
    end
endfunction

wire [39:0] input_vector;
assign input_vector = {data_in, state_in};

genvar n;
generate
    for (n = 0; n < 32; n = n + 1) begin : state_bits
        wire [39:0] mask = crc_mask(n);
        assign state_out[n] = ^(input_vector & mask);
    end
    for (n = 0; n < 8; n = n + 1) begin : data_bits
        wire [39:0] mask = crc_mask(n + 32);
        assign data_out[n] = ^(input_vector & mask);
    end
endgenerate
endmodule

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
    crc32_fixed core (
        .data_in(data_in),
        .state_in(state_in),
        .data_out(data_out),
        .state_out(state_out)
    );
endmodule

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
