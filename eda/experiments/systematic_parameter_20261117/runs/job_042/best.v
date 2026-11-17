module pw_crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    // Combine corresponding data and state bits before the CRC network.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant linear-transform masks for eight reflected CRC32 steps.
    // Indices 0..31 select next-state bits; 32..39 select shifted-out bits.
    function [7:0] crc_mask;
        input integer index;
        reg [31:0] c;
        reg [7:0] d;
        integer j;
        integer k;
        begin
            crc_mask = 8'b0;
            for (j = 0; j < 8; j = j + 1) begin
                c = 32'b1 << j;
                d = 8'b0;
                for (k = 0; k < 8; k = k + 1) begin
                    d[k] = c[0];
                    c = (c >> 1) ^ (32'hedb88320 & {32{c[0]}});
                end
                if (index < 32)
                    crc_mask[j] = c[index];
                else
                    crc_mask[j] = d[index-32];
            end
        end
    endfunction

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : state_bits
            localparam [7:0] MASK = crc_mask(n);
            wire lo;
            wire hi;
            assign lo = ^(q[3:0] & MASK[3:0]);
            assign hi = ^(q[7:4] & MASK[7:4]);
            if (n < 24) begin : shifted_state
                assign state_out[n] = (lo ^ hi) ^ state_in[n+8];
            end else begin : feedback_only
                assign state_out[n] = lo ^ hi;
            end
        end
        for (n = 0; n < 8; n = n + 1) begin : data_bits
            localparam [7:0] MASK = crc_mask(n+32);
            assign data_out[n] = ^(q & MASK);
        end
    endgenerate
endmodule
