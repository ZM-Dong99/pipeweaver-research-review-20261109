`timescale 1ns / 1ps
`default_nettype none

module pw_crc32_d16 (
    input  wire [15:0] data_in,
    input  wire [31:0] state_in,
    output wire [15:0] data_out,
    output wire [31:0] state_out
);
    // Combine corresponding data and state bits before the CRC matrix.
    wire [15:0] q;
    wire [31:0] operands;
    wire [47:0] result;
    assign q = data_in ^ state_in[15:0];
    assign operands = {state_in[31:16], q};
    assign state_out = result[31:0];
    assign data_out = result[47:32];

    // Elaborate the reflected CRC transformation on each low-state basis
    // vector. The feedback bits are also retained for data_out.
    function [15:0] crc_mask;
        input integer output_index;
        reg [31:0] s;
        reg [15:0] feedback;
        reg f;
        integer b;
        integer k;
        begin
            crc_mask = 16'b0;
            for (b = 0; b < 16; b = b + 1) begin
                s = 32'h00000001 << b;
                feedback = 16'b0;
                for (k = 0; k < 16; k = k + 1) begin
                    f = s[0];
                    feedback[k] = f;
                    s = (s >> 1) ^ (32'hedb88320 & {32{f}});
                end
                if (output_index < 32)
                    crc_mask[b] = s[output_index];
                else
                    crc_mask[b] = feedback[output_index-32];
            end
        end
    endfunction

    function [31:0] operand_mask;
        input integer output_index;
        reg [31:0] m;
        begin
            m = {16'b0, crc_mask(output_index)};
            // Upper initial-state bits shift down by sixteen positions.
            // They do not reach the feedback tap during these sixteen steps.
            if (output_index < 16)
                m[16+output_index] = 1'b1;
            operand_mask = m;
        end
    endfunction

    function integer population;
        input [31:0] mask;
        integer i;
        begin
            population = 0;
            for (i = 0; i < 32; i = i + 1)
                population = population + mask[i];
        end
    endfunction

    function integer selected_index;
        input [31:0] mask;
        input integer ordinal;
        integer i;
        integer seen;
        begin
            selected_index = 0;
            seen = 0;
            for (i = 0; i < 32; i = i + 1) begin
                if (mask[i]) begin
                    if (seen == ordinal)
                        selected_index = i;
                    seen = seen + 1;
                end
            end
        end
    endfunction

    function integer tree_size;
        input integer count;
        integer size;
        begin
            size = 1;
            while (size < count)
                size = size * 2;
            tree_size = size;
        end
    endfunction

    genvar o;
    genvar j;
    generate
        for (o = 0; o < 48; o = o + 1) begin : output_matrix
            localparam [31:0] MASK = operand_mask(o);
            localparam integer COUNT = population(MASK);
            localparam integer LEAVES = tree_size(COUNT);
            wire [2*LEAVES-1:1] tree;

            for (j = 0; j < LEAVES; j = j + 1) begin : leaf
                if (j < COUNT) begin : selected
                    localparam integer INDEX = selected_index(MASK, j);
                    assign tree[LEAVES+j] = operands[INDEX];
                end else begin : padding
                    assign tree[LEAVES+j] = 1'b0;
                end
            end

            for (j = 1; j < LEAVES; j = j + 1) begin : branch
                assign tree[j] = tree[2*j] ^ tree[2*j+1];
            end
            assign result[o] = tree[1];
        end
    endgenerate
endmodule

`default_nettype wire
