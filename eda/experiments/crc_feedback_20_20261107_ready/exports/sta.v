`default_nettype none

module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Fold the byte into the low state byte before the CRC matrix.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // One column of the fixed reflected CRC transformation.  Bits 31:0
    // are the next-state contribution; bits 39:32 are feedback outputs
    // in chronological (LSB-first) order.  Evaluated only at elaboration.
    function [39:0] column;
        input integer k;
        reg [31:0] s;
        reg [7:0] d;
        reg f;
        integer t;
        begin
            s = 32'h00000001 << k;
            d = 8'b0;
            for (t = 0; t < 8; t = t + 1) begin
                f = s[0];
                d[t] = f;
                s = (s >> 1) ^ ({32{f}} & 32'hedb88320);
            end
            column = {d, s};
        end
    endfunction

    function [7:0] row_mask;
        input integer r;
        reg [39:0] c;
        integer k;
        begin
            row_mask = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                c = column(k);
                row_mask[k] = c[r];
            end
        end
    endfunction

    function integer population;
        input [7:0] m;
        integer k;
        begin
            population = 0;
            for (k = 0; k < 8; k = k + 1)
                population = population + m[k];
        end
    endfunction

    function integer selected_bit;
        input [7:0] m;
        input integer ordinal;
        integer k;
        integer count;
        begin
            selected_bit = 0;
            count = 0;
            for (k = 0; k < 8; k = k + 1) begin
                if (m[k]) begin
                    if (count == ordinal)
                        selected_bit = k;
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar r, j;
    generate
        for (r = 0; r < 40; r = r + 1) begin : rows
            localparam [7:0] MASK = row_mask(r);
            localparam integer TERMS = population(MASK);
            localparam integer SHIFT_TERM = (r < 24) ? 1 : 0;
            localparam integer N = TERMS + SHIFT_TERM;
            wire [N-1:0] leaves;
            wire result;

            for (j = 0; j < TERMS; j = j + 1) begin : inputs_q
                localparam integer K = selected_bit(MASK, j);
                assign leaves[j] = q[K];
            end
            if (SHIFT_TERM != 0) begin : shifted_state
                assign leaves[TERMS] = state_in[r+8];
            end

            crc32_d8_parity #(.N(N)) parity (
                .x(leaves),
                .y(result)
            );

            if (r < 32) begin : state_result
                assign state_out[r] = result;
            end else begin : data_result
                assign data_out[r-32] = result;
            end
        end
    endgenerate
endmodule

// A balanced parity tree; all recursion terminates during elaboration.
module crc32_d8_parity #(
    parameter integer N = 1
) (
    input  wire [N-1:0] x,
    output wire y
);
    generate
        if (N == 1) begin : single
            assign y = x[0];
        end else begin : split
            localparam integer L = N/2;
            localparam integer R = N-L;
            wire a, b;
            crc32_d8_parity #(.N(L)) left_tree (
                .x(x[L-1:0]), .y(a)
            );
            crc32_d8_parity #(.N(R)) right_tree (
                .x(x[N-1:L]), .y(b)
            );
            assign y = a ^ b;
        end
    endgenerate
endmodule

`default_nettype wire
