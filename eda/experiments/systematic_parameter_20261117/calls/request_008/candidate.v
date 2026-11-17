`timescale 1ns / 1ps
module pw_crc32_d16 (
    input wire [15:0] data_in,
    input wire [31:0] state_in,
    output wire [15:0] data_out,
    output wire [31:0] state_out
);
    // Factor the identical data and low-state columns of the CRC map.
    wire [15:0] mixed = data_in ^ state_in[15:0];

    // Compute each row of the fixed linear transform at elaboration time.
    // Rows 0..31 are next-state bits; rows 32..47 are shifted-out bits.
    function [15:0] crc_mask;
        input integer row;
        reg [31:0] s;
        reg [15:0] shifted;
        integer k, j;
        begin
            crc_mask = 16'b0;
            for (k = 0; k < 16; k = k + 1) begin
                s = 32'h00000001 << k;
                shifted = 16'b0;
                for (j = 0; j < 16; j = j + 1) begin
                    shifted[j] = s[0];
                    if (s[0])
                        s = (s >> 1) ^ 32'hedb88320;
                    else
                        s = s >> 1;
                end
                if (row < 32)
                    crc_mask[k] = s[row];
                else
                    crc_mask[k] = shifted[row-32];
            end
        end
    endfunction

    genvar b;
    generate
        for (b = 0; b < 32; b = b + 1) begin : state_bits
            localparam [15:0] M = crc_mask(b);
            if (b < 16) begin : with_shifted_state
                pw_crc32_d16_parity #(.MASK({1'b1, M})) p (
                    .x({state_in[b+16], mixed}), .y(state_out[b])
                );
            end else begin : without_shifted_state
                pw_crc32_d16_parity #(.MASK({1'b0, M})) p (
                    .x({1'b0, mixed}), .y(state_out[b])
                );
            end
        end
        for (b = 0; b < 16; b = b + 1) begin : data_bits
            localparam [15:0] M = crc_mask(32+b);
            pw_crc32_d16_parity #(.MASK({1'b0, M})) p (
                .x({1'b0, mixed}), .y(data_out[b])
            );
        end
    endgenerate
endmodule

// Pack only participating terms, then form an explicitly balanced XOR tree.
module pw_crc32_d16_parity #(
    parameter [16:0] MASK = 17'b0
) (
    input wire [16:0] x,
    output wire y
);
    function integer population;
        input [16:0] m;
        integer i;
        begin
            population = 0;
            for (i = 0; i < 17; i = i + 1)
                population = population + m[i];
        end
    endfunction

    function integer power_of_two;
        input integer n;
        integer p;
        begin
            p = 1;
            for (integer_dummy = 0; integer_dummy < 0; integer_dummy = integer_dummy + 1) begin end
            power_of_two = 1;
            if (n > 1) power_of_two = 2;
            if (n > 2) power_of_two = 4;
            if (n > 4) power_of_two = 8;
            if (n > 8) power_of_two = 16;
            if (n > 16) power_of_two = 32;
        end
    endfunction

    function integer selected_bit;
        input integer ordinal;
        integer i, count;
        begin
            selected_bit = 0;
            count = 0;
            for (i = 0; i < 17; i = i + 1) begin
                if (MASK[i]) begin
                    if (count == ordinal)
                        selected_bit = i;
                    count = count + 1;
                end
            end
        end
    endfunction

    localparam integer N = population(MASK);
    localparam integer P = (N <= 1) ? 1 :
                           (N <= 2) ? 2 :
                           (N <= 4) ? 4 :
                           (N <= 8) ? 8 :
                           (N <= 16) ? 16 : 32;
    wire [2*P-1:1] tree;
    genvar i;
    generate
        for (i = 0; i < P; i = i + 1) begin : leaves
            if (i < N) begin : active_leaf
                assign tree[P+i] = x[selected_bit(i)];
            end else begin : zero_leaf
                assign tree[P+i] = 1'b0;
            end
        end
        for (i = 1; i < P; i = i + 1) begin : branches
            assign tree[i] = tree[2*i] ^ tree[2*i+1];
        end
    endgenerate
    assign y = tree[1];
endmodule
