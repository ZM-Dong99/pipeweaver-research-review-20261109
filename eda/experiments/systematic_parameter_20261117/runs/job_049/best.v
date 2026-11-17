module pw_crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    // Factor the matching data and low-state columns of the CRC matrix.
    wire [7:0] byte_mix;
    assign byte_mix = data_in ^ state_in[7:0];

    // Constant elaboration-time calculation of the reflected CRC matrix.
    // Each register holds a symbolic mask over byte_mix, not runtime state.
    function [7:0] crc_mask;
        input integer index;
        reg [7:0] s [0:31];
        reg [7:0] d [0:7];
        reg [7:0] feedback;
        integer i;
        integer j;
        begin
            for (j = 0; j < 32; j = j + 1)
                s[j] = 8'b0;
            for (i = 0; i < 8; i = i + 1) begin
                feedback = s[0] ^ (8'b00000001 << i);
                d[i] = feedback;
                for (j = 0; j < 31; j = j + 1)
                    s[j] = s[j+1];
                s[31] = 8'b0;
                for (j = 0; j < 32; j = j + 1)
                    if ((32'hedb88320 >> j) & 32'b1)
                        s[j] = s[j] ^ feedback;
            end
            if (index < 32)
                crc_mask = s[index];
            else
                crc_mask = d[index-32];
        end
    endfunction

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : state_bits
            localparam [7:0] MASK = crc_mask(n);
            wire correction;
            assign correction = ^(byte_mix & MASK);
            if (n < 24) begin : shifted_state
                assign state_out[n] = state_in[n+8] ^ correction;
            end else begin : correction_only
                assign state_out[n] = correction;
            end
        end
        for (n = 0; n < 8; n = n + 1) begin : data_bits
            localparam [7:0] MASK = crc_mask(32+n);
            assign data_out[n] = ^(byte_mix & MASK);
        end
    endgenerate
endmodule
