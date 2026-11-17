`timescale 1ns / 1ps
`default_nettype none

module pw_crc32_d16 (
    input  wire [15:0] data_in,
    input  wire [31:0] state_in,
    output wire [15:0] data_out,
    output wire [31:0] state_out
);

    // Combine paired state/data terms before distributing them to the
    // parallel CRC network.
    wire [15:0] q;
    assign q = data_in ^ state_in[15:0];

    // Constant propagation of symbolic input bits through the reflected
    // CRC32 recurrence. This function is evaluated only at elaboration.
    function [15:0] crc_mask;
        input integer index;
        reg [15:0] s [0:31];
        reg [15:0] d [0:15];
        reg [15:0] feedback;
        reg [31:0] poly;
        integer i;
        integer j;
        begin
            poly = 32'hedb88320;
            for (j = 0; j < 32; j = j + 1)
                s[j] = 16'b0;
            for (i = 0; i < 16; i = i + 1) begin
                feedback = s[0] ^ (16'h0001 << i);
                d[i] = feedback;
                for (j = 0; j < 31; j = j + 1)
                    s[j] = s[j+1];
                s[31] = 16'b0;
                for (j = 0; j < 32; j = j + 1)
                    if (poly[j])
                        s[j] = s[j] ^ feedback;
            end
            if (index < 32)
                crc_mask = s[index];
            else
                crc_mask = d[index-32];
        end
    endfunction

    // Pack selected terms before reduction, avoiding gaps in the parity
    // operands and exposing a compact, balanced parallel XOR expression.
    function [15:0] pack_terms;
        input [15:0] value;
        input [15:0] mask;
        integer i;
        integer count;
        begin
            pack_terms = 16'b0;
            count = 0;
            for (i = 0; i < 16; i = i + 1) begin
                if (mask[i]) begin
                    pack_terms[count] = value[i];
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : state_bits
            localparam [15:0] MASK = crc_mask(n);
            wire parity;
            assign parity = ^pack_terms(q, MASK);
            if (n < 16) begin : shifted_state
                assign state_out[n] = parity ^ state_in[n+16];
            end else begin : crc_only
                assign state_out[n] = parity;
            end
        end
        for (n = 0; n < 16; n = n + 1) begin : data_bits
            localparam [15:0] MASK = crc_mask(32+n);
            assign data_out[n] = ^pack_terms(q, MASK);
        end
    endgenerate

endmodule

`default_nettype wire
