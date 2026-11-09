`resetall
`timescale 1ns / 1ps
`default_nettype none

module crc32_core (
    input wire [7:0] data_in,
    input wire [31:0] state_in,
    output wire [7:0] data_out,
    output wire [31:0] state_out
);

function [31:0] bit_reverse;
    input [31:0] value;
    integer k;
    begin
        for (k = 0; k < 32; k = k + 1)
            bit_reverse[k] = value[31-k];
    end
endfunction

function [31:0] galois_step;
    input [31:0] value;
    reg feedback;
    integer k;
    begin
        feedback = value[31];
        galois_step = 32'b0;
        galois_step[0] = feedback;
        for (k = 1; k < 32; k = k + 1)
            galois_step[k] = value[k-1] ^ (feedback & 32'h04c11db7[k]);
    end
endfunction

wire [31:0] s0;
wire [31:0] s1;
wire [31:0] s2;
wire [31:0] s3;
wire [31:0] s4;
wire [31:0] s5;
wire [31:0] s6;
wire [31:0] s7;
wire [31:0] s8;

assign s0 = bit_reverse(state_in);
assign s1 = galois_step(s0);
assign s2 = galois_step(s1);
assign s3 = galois_step(s2);
assign s4 = galois_step(s3);
assign s5 = galois_step(s4);
assign s6 = galois_step(s5);
assign s7 = galois_step(s6);
assign s8 = galois_step(s7);
assign state_out = bit_reverse(s8);
assign data_out = data_in;

endmodule

module lfsr #(
    parameter LFSR_WIDTH = 31,
    parameter LFSR_POLY = 31'h10000001,
    parameter LFSR_CONFIG = "FIBONACCI",
    parameter LFSR_FEED_FORWARD = 0,
    parameter REVERSE = 0,
    parameter DATA_WIDTH = 8,
    parameter STYLE = "AUTO"
) (
    input wire [DATA_WIDTH-1:0] data_in,
    input wire [LFSR_WIDTH-1:0] state_in,
    output wire [DATA_WIDTH-1:0] data_out,
    output wire [LFSR_WIDTH-1:0] state_out
);

crc32_core core (
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

`resetall
