module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Common byte-wide input syndrome.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Feedback bits emitted during the eight reflected Galois steps.
    assign data_out[5:0] = q[5:0];
    assign data_out[6] = q[6] ^ q[0];
    assign data_out[7] = q[7] ^ q[1];

    // Constant elaboration-time computation of each syndrome-to-state row.
    function automatic [7:0] row_mask;
        input integer bit_index;
        reg [31:0] c;
        integer j, t;
        begin
            row_mask = 8'b0;
            for (j = 0; j < 8; j = j + 1) begin
                c = 32'h00000001 << j;
                for (t = 0; t < 8; t = t + 1) begin
                    if (c[0])
                        c = (c >> 1) ^ 32'hedb88320;
                    else
                        c = c >> 1;
                end
                row_mask[j] = c[bit_index];
            end
        end
    endfunction

    function automatic integer population;
        input [7:0] mask;
        integer j;
        begin
            population = 0;
            for (j = 0; j < 8; j = j + 1)
                population = population + (mask[j] ? 1 : 0);
        end
    endfunction

    function automatic integer selected_bit;
        input [7:0] mask;
        input integer ordinal;
        integer j, seen;
        begin
            selected_bit = 0;
            seen = 0;
            for (j = 0; j < 8; j = j + 1) begin
                if (mask[j]) begin
                    if (seen == ordinal)
                        selected_bit = j;
                    seen = seen + 1;
                end
            end
        end
    endfunction

    genvar b, k;
    generate
        for (b = 0; b < 32; b = b + 1) begin : output_row
            localparam [7:0] MASK = row_mask(b);
            localparam integer COUNT = population(MASK);
            wire [15:0] leaf;
            wire [7:0] level1;
            wire [3:0] level2;
            wire [1:0] level3;

            // Pack only actual operands before building a balanced XOR tree.
            // The shifted state bit participates in the same tree.
            for (k = 0; k < 16; k = k + 1) begin : operands
                if (k < COUNT) begin : syndrome_term
                    localparam integer INDEX = selected_bit(MASK, k);
                    assign leaf[k] = q[INDEX];
                end else if ((k == COUNT) && (b < 24)) begin : shifted_state
                    assign leaf[k] = state_in[b+8];
                end else begin : padding
                    assign leaf[k] = 1'b0;
                end
            end
            for (k = 0; k < 8; k = k + 1) begin : first_level
                assign level1[k] = leaf[2*k] ^ leaf[2*k+1];
            end
            for (k = 0; k < 4; k = k + 1) begin : second_level
                assign level2[k] = level1[2*k] ^ level1[2*k+1];
            end
            for (k = 0; k < 2; k = k + 1) begin : third_level
                assign level3[k] = level2[2*k] ^ level2[2*k+1];
            end
            assign state_out[b] = level3[0] ^ level3[1];
        end
    endgenerate
endmodule
