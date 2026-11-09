module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Combine paired inputs before the fixed linear transform.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant coefficient generation for eight reflected CRC shifts.
    // This function is evaluated only with elaboration-time arguments.
    function automatic [7:0] crc_mask(input integer bit_index);
        reg [31:0] v;
        integer k, s;
        begin
            crc_mask = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                v = 32'h00000001 << k;
                for (s = 0; s < 8; s = s + 1) begin
                    if (v[0])
                        v = (v >> 1) ^ 32'hedb88320;
                    else
                        v = v >> 1;
                end
                crc_mask[k] = v[bit_index];
            end
        end
    endfunction

    function automatic integer popcount8(input [7:0] mask);
        integer k;
        begin
            popcount8 = 0;
            for (k = 0; k < 8; k = k + 1)
                popcount8 = popcount8 + (mask[k] ? 1 : 0);
        end
    endfunction

    function automatic integer selected_bit(
        input [7:0] mask,
        input integer ordinal
    );
        integer k, count;
        begin
            selected_bit = 0;
            count = 0;
            for (k = 0; k < 8; k = k + 1) begin
                if (mask[k]) begin
                    if (count == ordinal)
                        selected_bit = k;
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar b, j;
    generate
        for (b = 0; b < 32; b = b + 1) begin : output_bit
            localparam [7:0] MASK = crc_mask(b);
            localparam integer N = popcount8(MASK);
            wire [7:0] leaf;
            wire [3:0] level1;
            wire [1:0] level2;
            wire result;

            // Pack selected terms into a balanced tree. Where possible,
            // include the shifted state term inside that same tree.
            for (j = 0; j < 8; j = j + 1) begin : leaves
                if (j < N) begin : q_term
                    localparam integer Q_INDEX = selected_bit(MASK, j);
                    assign leaf[j] = q[Q_INDEX];
                end else if ((j == N) && (b < 24)) begin : state_term
                    assign leaf[j] = state_in[b+8];
                end else begin : zero_term
                    assign leaf[j] = 1'b0;
                end
            end

            for (j = 0; j < 4; j = j + 1) begin : first_level
                assign level1[j] = leaf[2*j] ^ leaf[2*j+1];
            end
            for (j = 0; j < 2; j = j + 1) begin : second_level
                assign level2[j] = level1[2*j] ^ level1[2*j+1];
            end
            assign result = level2[0] ^ level2[1];

            if ((N == 8) && (b < 24)) begin : full_tree
                assign state_out[b] = result ^ state_in[b+8];
            end else begin : complete_tree
                assign state_out[b] = result;
            end
        end
    endgenerate

    // Feedback bits emitted during the eight reflected shifts.
    // Polynomial bit 5 first affects the feedback at shift 6.
    assign data_out[5:0] = q[5:0];
    assign data_out[6] = q[6] ^ q[0];
    assign data_out[7] = q[7] ^ q[1];
endmodule
