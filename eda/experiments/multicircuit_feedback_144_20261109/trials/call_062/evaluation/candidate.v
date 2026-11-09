`timescale 1ns / 1ps
`default_nettype none

module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    // Factor the identical data/state contributions before the CRC matrix.
    wire [7:0] t;
    assign t = data_in ^ state_in[7:0];

    // Constant-only symbolic evaluation of eight reflected CRC steps.
    // Indices 0..31 describe state_out; 32..39 describe data_out.
    function [7:0] crc_mask;
        input integer index;
        reg [7:0] s [0:31];
        reg [7:0] feedback;
        reg [7:0] selected_output;
        reg [31:0] polynomial;
        integer j;
        integer k;
        begin
            polynomial = 32'hedb88320;
            selected_output = 8'b0;
            feedback = 8'b0;
            for (j = 0; j < 32; j = j + 1)
                s[j] = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                feedback = s[0] ^ (8'b00000001 << k);
                if (index == 32+k)
                    selected_output = feedback;
                for (j = 0; j < 31; j = j + 1)
                    s[j] = s[j+1];
                s[31] = 8'b0;
                for (j = 0; j < 32; j = j + 1)
                    if (polynomial[j])
                        s[j] = s[j] ^ feedback;
            end
            if (index < 32)
                crc_mask = s[index];
            else
                crc_mask = selected_output;
        end
    endfunction

    function integer population;
        input [7:0] mask;
        integer j;
        begin
            population = 0;
            for (j = 0; j < 8; j = j + 1)
                population = population + (mask[j] ? 1 : 0);
        end
    endfunction

    function integer selected_bit;
        input [7:0] mask;
        input integer ordinal;
        integer j;
        integer count;
        begin
            selected_bit = 0;
            count = 0;
            for (j = 0; j < 8; j = j + 1) begin
                if (mask[j]) begin
                    if (count == ordinal)
                        selected_bit = j;
                    count = count + 1;
                end
            end
        end
    endfunction

    wire [39:0] result;
    genvar n;
    genvar p;
    generate
        for (n = 0; n < 40; n = n + 1) begin : output_matrix
            localparam [7:0] MASK = crc_mask(n);
            localparam integer COUNT = population(MASK);
            wire [15:0] leaves;
            wire [7:0] level1;
            wire [3:0] level2;
            wire [1:0] level3;

            // Pack only participating terms into a balanced parity tree.
            // The shifted state bit is a leaf, not a final serial XOR.
            for (p = 0; p < 16; p = p + 1) begin : make_leaf
                if (p < COUNT) begin : feedback_leaf
                    localparam integer BIT_INDEX = selected_bit(MASK, p);
                    assign leaves[p] = t[BIT_INDEX];
                end else if ((p == COUNT) && (n < 24)) begin : state_leaf
                    assign leaves[p] = state_in[n+8];
                end else begin : zero_leaf
                    assign leaves[p] = 1'b0;
                end
            end
            for (p = 0; p < 8; p = p + 1) begin : first_level
                assign level1[p] = leaves[2*p] ^ leaves[2*p+1];
            end
            for (p = 0; p < 4; p = p + 1) begin : second_level
                assign level2[p] = level1[2*p] ^ level1[2*p+1];
            end
            for (p = 0; p < 2; p = p + 1) begin : third_level
                assign level3[p] = level2[2*p] ^ level2[2*p+1];
            end
            assign result[n] = level3[0] ^ level3[1];
        end
    endgenerate

    assign state_out = result[31:0];
    assign data_out = result[39:32];
endmodule

`default_nettype wire
