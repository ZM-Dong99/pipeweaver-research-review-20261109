module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Common input parities for this fixed reflected CRC32 instance.
    wire [7:0] t;
    assign t = data_in ^ state_in[7:0];

    // Feedback emitted by each of the eight reflected Galois steps.
    assign data_out[5:0] = t[5:0];
    assign data_out[6] = t[6] ^ t[0];
    assign data_out[7] = t[7] ^ t[1];

    // Elaboration-only construction of the byte-update linear transform.
    function [7:0] byte_mask;
        input integer bit_number;
        reg [31:0] basis;
        integer k;
        integer step;
        begin
            byte_mask = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                basis = 32'h00000001 << k;
                for (step = 0; step < 8; step = step + 1) begin
                    if (basis[0])
                        basis = (basis >> 1) ^ 32'hedb88320;
                    else
                        basis = basis >> 1;
                end
                byte_mask[k] = basis[bit_number];
            end
        end
    endfunction

    function integer bit_count;
        input [7:0] mask;
        integer k;
        begin
            bit_count = 0;
            for (k = 0; k < 8; k = k + 1)
                bit_count = bit_count + ((mask >> k) & 8'h01);
        end
    endfunction

    genvar b;
    genvar k;
    generate
        for (b = 0; b < 32; b = b + 1) begin : output_bit
            localparam [7:0] MASK = byte_mask(b);
            localparam integer TC = bit_count(MASK);
            localparam integer NC = TC + ((b < 24) ? 1 : 0);
            wire [NC-1:0] terms;

            for (k = 0; k < 8; k = k + 1) begin : input_term
                if (MASK[k]) begin : selected
                    localparam integer INDEX = bit_count(MASK & ((8'h01 << k) - 8'h01));
                    assign terms[INDEX] = t[k];
                end
            end

            if (b < 24) begin : shifted_state
                assign terms[TC] = state_in[b+8];
            end

            crc32_d8_balanced_xor #(.N(NC)) parity (
                .x(terms),
                .y(state_out[b])
            );
        end
    endgenerate
endmodule

module crc32_d8_balanced_xor #(
    parameter integer N = 1
) (
    input  wire [N-1:0] x,
    output wire y
);
    generate
        if (N == 1) begin : leaf
            assign y = x[0];
        end else begin : branch
            localparam integer L = N/2;
            wire lo;
            wire hi;
            crc32_d8_balanced_xor #(.N(L)) left (
                .x(x[L-1:0]), .y(lo)
            );
            crc32_d8_balanced_xor #(.N(N-L)) right (
                .x(x[N-1:L]), .y(hi)
            );
            assign y = lo ^ hi;
        end
    endgenerate
endmodule
