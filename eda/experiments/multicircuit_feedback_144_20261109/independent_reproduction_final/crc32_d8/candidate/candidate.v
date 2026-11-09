module crc32_d8 (
    input wire [7:0] data_in,
    input wire [31:0] state_in,
    output wire [7:0] data_out,
    output wire [31:0] state_out
);
    // Combine corresponding data and state bits before the CRC matrix.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Column of the reflected eight-bit CRC transition matrix.
    function [31:0] crc_column;
        input integer column;
        reg [31:0] v;
        integer step;
        begin
            v = 32'h00000001 << column;
            for (step = 0; step < 8; step = step + 1) begin
                if (v[0])
                    v = (v >> 1) ^ 32'hedb88320;
                else
                    v = v >> 1;
            end
            crc_column = v;
        end
    endfunction

    function [7:0] crc_row;
        input integer row;
        reg [31:0] column_value;
        integer k;
        begin
            crc_row = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                column_value = crc_column(k);
                crc_row[k] = column_value[row];
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

    function integer position;
        input [7:0] mask;
        input integer index;
        integer k;
        begin
            position = 0;
            for (k = 0; k < index; k = k + 1)
                position = position + mask[k];
        end
    endfunction

    genvar b, k;
    generate
        for (b = 0; b < 32; b = b + 1) begin : rows
            localparam [7:0] MASK = crc_row(b);
            localparam integer TERMS = population(MASK);
            localparam integer N = TERMS + ((b < 24) ? 1 : 0);
            wire [N-1:0] operands;
            for (k = 0; k < 8; k = k + 1) begin : inputs_to_row
                if (MASK[k]) begin : selected
                    assign operands[position(MASK, k)] = q[k];
                end
            end
            if (b < 24) begin : shifted_state
                assign operands[TERMS] = state_in[b+8];
            end
            crc32_d8_balanced_xor #(.N(N)) parity (
                .a(operands),
                .y(state_out[b])
            );
        end
    endgenerate

    // The data output is the sequence of feedback bits, not the input byte.
    assign data_out[5:0] = q[5:0];
    assign data_out[6] = q[6] ^ q[0];
    assign data_out[7] = q[7] ^ q[1];
endmodule

module crc32_d8_balanced_xor #(
    parameter integer N = 1
) (
    input wire [N-1:0] a,
    output wire y
);
    generate
        if (N == 1) begin : leaf
            assign y = a[0];
        end else begin : branch
            localparam integer L = N / 2;
            wire lo, hi;
            crc32_d8_balanced_xor #(.N(L)) left_tree (
                .a(a[L-1:0]), .y(lo)
            );
            crc32_d8_balanced_xor #(.N(N-L)) right_tree (
                .a(a[N-1:L]), .y(hi)
            );
            assign y = lo ^ hi;
        end
    endgenerate
endmodule
