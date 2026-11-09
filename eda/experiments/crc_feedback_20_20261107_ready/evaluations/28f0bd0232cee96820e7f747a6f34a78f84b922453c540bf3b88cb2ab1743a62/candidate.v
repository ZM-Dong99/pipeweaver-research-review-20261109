`default_nettype none
module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    // Factor the eight repeated input/state pairs before the CRC matrix.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant elaboration-time construction of the reflected CRC matrix.
    // Rows 0..31 are next-state bits; rows 32..39 are feedback bits
    // emitted in chronological, least-significant-bit-first order.
    function [7:0] crc_row;
        input integer row;
        reg [31:0] c;
        reg [7:0] feedback;
        integer k;
        integer j;
        begin
            crc_row = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                c = 32'h00000001 << k;
                feedback = 8'b0;
                for (j = 0; j < 8; j = j + 1) begin
                    feedback[j] = c[0];
                    if (c[0])
                        c = (c >> 1) ^ 32'hedb88320;
                    else
                        c = c >> 1;
                end
                if (row < 32)
                    crc_row[k] = c[row];
                else
                    crc_row[k] = feedback[row-32];
            end
        end
    endfunction

    genvar b;
    generate
        for (b = 0; b < 32; b = b + 1) begin : g_state
            localparam [7:0] MASK = crc_row(b);
            wire [7:0] terms;
            wire [3:0] pair_xor;
            wire [1:0] quad_xor;
            wire correction;
            assign terms = q & MASK;
            assign pair_xor[0] = terms[0] ^ terms[1];
            assign pair_xor[1] = terms[2] ^ terms[3];
            assign pair_xor[2] = terms[4] ^ terms[5];
            assign pair_xor[3] = terms[6] ^ terms[7];
            assign quad_xor[0] = pair_xor[0] ^ pair_xor[1];
            assign quad_xor[1] = pair_xor[2] ^ pair_xor[3];
            assign correction = quad_xor[0] ^ quad_xor[1];
            if (b < 24) begin : g_shift
                assign state_out[b] = state_in[b+8] ^ correction;
            end else begin : g_no_shift
                assign state_out[b] = correction;
            end
        end
        for (b = 0; b < 8; b = b + 1) begin : g_data
            localparam [7:0] MASK = crc_row(32+b);
            assign data_out[b] = ^(q & MASK);
        end
    endgenerate
endmodule
`default_nettype wire
