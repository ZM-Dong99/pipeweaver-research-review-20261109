`default_nettype none

module pw_crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Combine corresponding data and state bits before the CRC transform.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant symbolic evaluation of eight reflected Galois steps.
    // Each eight-bit slice records dependence on q, not runtime state.
    function [7:0] crc_mask;
        input integer index;
        reg [255:0] m;
        reg [63:0] d;
        reg [7:0] feedback;
        integer j;
        integer step;
        begin
            m = 256'b0;
            d = 64'b0;
            for (j = 0; j < 8; j = j + 1)
                m[j*8 +: 8] = 8'h01 << j;
            for (step = 0; step < 8; step = step + 1) begin
                feedback = m[7:0];
                d[step*8 +: 8] = feedback;
                m = m >> 8;
                for (j = 0; j < 32; j = j + 1) begin
                    if ((32'hedb88320 >> j) & 32'h00000001)
                        m[j*8 +: 8] = m[j*8 +: 8] ^ feedback;
                end
            end
            if (index < 32)
                crc_mask = m[index*8 +: 8];
            else
                crc_mask = d[(index-32)*8 +: 8];
        end
    endfunction

    function integer population;
        input [7:0] mask;
        integer j;
        begin
            population = 0;
            for (j = 0; j < 8; j = j + 1)
                population = population + mask[j];
        end
    endfunction

    function integer selected_bit;
        input [7:0] mask;
        input integer ordinal;
        integer j;
        integer seen;
        begin
            selected_bit = 0;
            seen = 0;
            for (j = 0; j < 8; j = j + 1) begin
                if (mask[j]) begin
                    if (seen == ordinal)
                        selected_bit = j;
                    seen = seen + 1;
                end
            end
        end
    endfunction

    genvar n;
    genvar k;
    generate
        for (n = 0; n < 40; n = n + 1) begin : outputs_gen
            localparam [7:0] MASK = crc_mask(n);
            localparam integer Q_COUNT = population(MASK);
            localparam integer HAS_SHIFT = (n < 24) ? 1 : 0;
            localparam integer COUNT = Q_COUNT + HAS_SHIFT;
            wire value;
            if (COUNT == 0) begin : zero_gen
                assign value = 1'b0;
            end else begin : nonzero_gen
                wire [COUNT-1:0] terms;
                for (k = 0; k < Q_COUNT; k = k + 1) begin : terms_gen
                    localparam integer BIT_INDEX = selected_bit(MASK, k);
                    assign terms[k] = q[BIT_INDEX];
                end
                if (HAS_SHIFT) begin : shifted_state_gen
                    assign terms[Q_COUNT] = state_in[n+8];
                end
                pw_crc32_d8_balanced_xor #(.N(COUNT)) tree (
                    .a(terms),
                    .y(value)
                );
            end
            if (n < 32) begin : state_gen
                assign state_out[n] = value;
            end else begin : data_gen
                assign data_out[n-32] = value;
            end
        end
    endgenerate
endmodule

module pw_crc32_d8_balanced_xor #(
    parameter integer N = 1
) (
    input  wire [N-1:0] a,
    output wire y
);
    generate
        if (N == 1) begin : leaf
            assign y = a[0];
        end else begin : branch
            localparam integer LEFT = N/2;
            localparam integer RIGHT = N-LEFT;
            wire yl;
            wire yr;
            pw_crc32_d8_balanced_xor #(.N(LEFT)) left_tree (
                .a(a[LEFT-1:0]), .y(yl)
            );
            pw_crc32_d8_balanced_xor #(.N(RIGHT)) right_tree (
                .a(a[N-1:LEFT]), .y(yr)
            );
            assign y = yl ^ yr;
        end
    endgenerate
endmodule

`default_nettype wire
