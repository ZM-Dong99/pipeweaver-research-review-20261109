`resetall
`timescale 1ns / 1ps
`default_nettype none

module crc32_fixed (
    input wire [7:0] data_in,
    input wire [31:0] state_in,
    output wire [7:0] data_out,
    output wire [31:0] state_out
);
    // Factor the identical data and low-state columns before the CRC map.
    wire [7:0] mixed;
    assign mixed = data_in ^ state_in[7:0];

    // Constant symbolic simulation of the reflected eight-step CRC map.
    // Each symbolic bit is a mask over mixed, not a runtime state bit.
    function [7:0] crc_mask;
        input integer index;
        reg [7:0] s [0:31];
        reg [7:0] feedback_masks [0:7];
        reg [7:0] feedback;
        integer i;
        integer j;
        begin
            for (j = 0; j < 32; j = j + 1) begin
                s[j] = 8'b0;
                if (j < 8)
                    s[j] = 8'b1 << j;
            end
            for (i = 0; i < 8; i = i + 1) begin
                feedback = s[0];
                feedback_masks[i] = feedback;
                for (j = 0; j < 31; j = j + 1)
                    s[j] = s[j+1];
                s[31] = 8'b0;
                for (j = 0; j < 32; j = j + 1) begin
                    if ((32'hedb88320 >> j) & 1'b1)
                        s[j] = s[j] ^ feedback;
                end
            end
            if (index < 32)
                crc_mask = s[index];
            else
                crc_mask = feedback_masks[index-32];
        end
    endfunction

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : state_bits
            localparam [7:0] MASK = crc_mask(n);
            wire correction;
            assign correction = ^(mixed & MASK);
            if (n < 24) begin : shifted
                assign state_out[n] = state_in[n+8] ^ correction;
            end else begin : unshifted
                assign state_out[n] = correction;
            end
        end
        for (n = 0; n < 8; n = n + 1) begin : data_bits
            localparam [7:0] MASK = crc_mask(n+32);
            assign data_out[n] = ^(mixed & MASK);
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

module crc32_d8 (
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
