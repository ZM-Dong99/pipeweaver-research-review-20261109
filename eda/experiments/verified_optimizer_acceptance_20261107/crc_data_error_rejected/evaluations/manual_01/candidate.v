module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    // Fold the input byte into the low state byte before the
    // fixed, linear reflected-CRC transform.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant elaboration function: select the byte contributions
    // to one result bit after eight reflected Galois steps.
    function automatic [7:0] byte_mask;
        input integer bit_index;
        reg [31:0] c;
        integer j;
        integer k;
        begin
            byte_mask = 8'b0;
            for (j = 0; j < 8; j = j + 1) begin
                c = 32'h00000001 << j;
                for (k = 0; k < 8; k = k + 1) begin
                    if (c[0])
                        c = (c >> 1) ^ 32'hedb88320;
                    else
                        c = c >> 1;
                end
                byte_mask[j] = c[bit_index];
            end
        end
    endfunction

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : result_bit
            localparam [7:0] MASK = byte_mask(n);
            wire lower_parity;
            wire upper_parity;
            assign lower_parity = ^(q[3:0] & MASK[3:0]);
            assign upper_parity = ^(q[7:4] & MASK[7:4]);
            if (n < 24) begin : shifted_state
                assign state_out[n] = ^{state_in[n+8],
                                        lower_parity, upper_parity};
            end else begin : byte_only
                assign state_out[n] = lower_parity ^ upper_parity;
            end
        end
    endgenerate

    // The observed data output is the sequence of feedback bits,
    // not a copy of the input byte or simply the original state byte.
    assign data_out[4:0] = q[4:0];
    assign data_out[5] = q[5] ^ q[0];
    assign data_out[6] = q[6] ^ q[1];
    assign data_out[7] = q[7] ^ q[2];

endmodule
