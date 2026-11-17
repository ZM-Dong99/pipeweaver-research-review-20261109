`timescale 1ns / 1ps
`default_nettype none

module pw_crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);

    // Combine the byte with the corresponding current-state bits before
    // distributing it through the parallel CRC transformation.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant coefficient row for eight reflected CRC32 shifts.
    // This function runs at elaboration; it does not infer a serial datapath.
    function [7:0] crc_row;
        input integer row;
        reg [31:0] c;
        integer k;
        integer j;
        begin
            crc_row = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                c = 32'h00000001 << k;
                for (j = 0; j < 8; j = j + 1) begin
                    c = (c >> 1) ^ (32'hedb88320 & {32{c[0]}});
                end
                crc_row[k] = c[row];
            end
        end
    endfunction

    wire [31:0] shifted_state;
    assign shifted_state = {8'b0, state_in[31:8]};

    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : output_rows
            localparam [7:0] MASK = crc_row(n);
            wire [7:0] terms;
            wire [3:0] level1;
            wire [1:0] level2;
            assign terms = q & MASK;
            assign level1[0] = terms[0] ^ terms[1];
            assign level1[1] = terms[2] ^ terms[3];
            assign level1[2] = terms[4] ^ terms[5];
            assign level1[3] = terms[6] ^ terms[7];
            assign level2[0] = level1[0] ^ level1[1];
            assign level2[1] = level1[2] ^ level1[3];
            assign state_out[n] = (level2[0] ^ level2[1]) ^ shifted_state[n];
        end
    endgenerate

    // Actual feedback bits shifted out during the eight iterations.
    // The reflected polynomial's lowest set bit is bit five, so the
    // first two feedback bits reappear in feedback positions six and seven.
    assign data_out[5:0] = q[5:0];
    assign data_out[6] = q[6] ^ q[0];
    assign data_out[7] = q[7] ^ q[1];

endmodule

`default_nettype wire
