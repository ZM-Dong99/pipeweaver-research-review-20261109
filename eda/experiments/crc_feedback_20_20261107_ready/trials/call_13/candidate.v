module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    // Combine the equivalent data and low-state contributions first.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Elaboration-only construction of the fixed reflected CRC matrix.
    // Indices 0..31 select next-state bits; 32..39 select feedback bits
    // in their original, LSB-first data_out ordering.
    function [7:0] crc_mask;
        input integer index;
        reg [31:0] v;
        integer k;
        integer t;
        begin
            crc_mask = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                v = 32'h00000001 << k;
                for (t = 0; t < 8; t = t + 1) begin
                    if (index == 32 + t)
                        crc_mask[k] = v[0];
                    if (v[0])
                        v = (v >> 1) ^ 32'hedb88320;
                    else
                        v = v >> 1;
                end
                if (index < 32)
                    crc_mask[k] = v[index];
            end
        end
    endfunction

    function parity8;
        input [7:0] x;
        begin
            parity8 = ((x[0] ^ x[1]) ^ (x[2] ^ x[3]))
                    ^ ((x[4] ^ x[5]) ^ (x[6] ^ x[7]));
        end
    endfunction

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : g_state
            localparam [7:0] MASK = crc_mask(n);
            wire contribution;
            assign contribution = parity8(q & MASK);
            if (n < 24) begin : g_shift
                assign state_out[n] = state_in[n+8] ^ contribution;
            end else begin : g_no_shift
                assign state_out[n] = contribution;
            end
        end
        for (n = 0; n < 8; n = n + 1) begin : g_data
            localparam [7:0] MASK = crc_mask(32+n);
            assign data_out[n] = parity8(q & MASK);
        end
    endgenerate
endmodule
