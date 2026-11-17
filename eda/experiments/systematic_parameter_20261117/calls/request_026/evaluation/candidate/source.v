`timescale 1ns / 1ps
`default_nettype none

module pw_crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    // Combine the byte with the portion of the state entering feedback.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant linear-transform masks.  Indices 0..31 are next-state
    // contributions; indices 32..39 are the successive feedback bits.
    function [7:0] crc_mask;
        input integer index;
        reg [31:0] s;
        reg f;
        integer b;
        integer k;
        begin
            crc_mask = 8'b0;
            for (b = 0; b < 8; b = b + 1) begin
                s = 32'b0;
                for (k = 0; k < 8; k = k + 1) begin
                    f = s[0] ^ (k == b);
                    if (index == 32+k)
                        crc_mask[b] = f;
                    s = (s >> 1) ^ (f ? 32'hedb88320 : 32'b0);
                end
                if (index < 32)
                    crc_mask[b] = s[index];
            end
        end
    endfunction

    function integer population;
        input [7:0] mask;
        integer k;
        begin
            population = 0;
            for (k = 0; k < 8; k = k + 1)
                population = population + mask[k];
        end
    endfunction

    function integer power_of_two;
        input integer count;
        integer k;
        begin
            power_of_two = 1;
            for (k = 0; k < 4; k = k + 1)
                if (power_of_two < count)
                    power_of_two = power_of_two * 2;
        end
    endfunction

    function integer selected_bit;
        input [7:0] mask;
        input integer ordinal;
        integer k;
        integer count;
        begin
            count = 0;
            selected_bit = 0;
            for (k = 0; k < 8; k = k + 1) begin
                if (mask[k]) begin
                    if (count == ordinal)
                        selected_bit = k;
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar o, j;
    generate
        for (o = 0; o < 40; o = o + 1) begin : output_parity
            localparam [7:0] MASK = crc_mask(o);
            localparam integer TERMS = population(MASK);
            localparam integer HAS_STATE = (o < 24) ? 1 : 0;
            localparam integer LEAVES = power_of_two(TERMS + HAS_STATE);
            wire [2*LEAVES-1:1] tree;

            for (j = 0; j < LEAVES; j = j + 1) begin : leaf
                if (j < TERMS) begin : feedback_term
                    localparam integer BIT_INDEX = selected_bit(MASK, j);
                    assign tree[LEAVES+j] = q[BIT_INDEX];
                end else if ((j == TERMS) && HAS_STATE) begin : shifted_state
                    assign tree[LEAVES+j] = state_in[o+8];
                end else begin : padding
                    assign tree[LEAVES+j] = 1'b0;
                end
            end

            for (j = 1; j < LEAVES; j = j + 1) begin : branch
                assign tree[j] = tree[2*j] ^ tree[2*j+1];
            end

            if (o < 32) begin : state_result
                assign state_out[o] = tree[1];
            end else begin : data_result
                assign data_out[o-32] = tree[1];
            end
        end
    endgenerate
endmodule

`default_nettype wire
