module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Byte-wide input/state cancellation, before the CRC linear map.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // The shifted-out bits are the successive reflected feedback bits,
    // not the input byte and not simply q.
    assign data_out[4:0] = q[4:0];
    assign data_out[5] = q[5] ^ q[0];
    assign data_out[6] = q[6] ^ q[1];
    assign data_out[7] = q[7] ^ q[2];

    // Constant elaboration: obtain one row of the reflected byte CRC map.
    function automatic [7:0] row_mask;
        input integer output_bit;
        reg [31:0] c;
        integer b, step;
        begin
            row_mask = 8'b0;
            for (b = 0; b < 8; b = b + 1) begin
                c = 32'h00000001 << b;
                for (step = 0; step < 8; step = step + 1) begin
                    if (c[0])
                        c = (c >> 1) ^ 32'hedb88320;
                    else
                        c = c >> 1;
                end
                row_mask[b] = c[output_bit];
            end
        end
    endfunction

    function automatic integer population;
        input [7:0] mask;
        integer k;
        begin
            population = 0;
            for (k = 0; k < 8; k = k + 1)
                population = population + mask[k];
        end
    endfunction

    function automatic integer selected_bit;
        input [7:0] mask;
        input integer ordinal;
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

    genvar n, k;
    generate
        for (n = 0; n < 32; n = n + 1) begin : output_rows
            localparam [7:0] MASK = row_mask(n);
            localparam integer TERMS = population(MASK);
            wire [15:0] leaves;
            wire [7:0] level1;
            wire [3:0] level2;
            wire [1:0] level3;

            // Pack only live terms, including the shifted state term,
            // into a balanced parity tree. Padding is constant zero.
            for (k = 0; k < 16; k = k + 1) begin : make_leaves
                if (k < TERMS) begin : feedback_term
                    localparam integer INDEX = selected_bit(MASK, k);
                    assign leaves[k] = q[INDEX];
                end else if ((k == TERMS) && (n < 24)) begin : shifted_term
                    assign leaves[k] = state_in[n+8];
                end else begin : padding
                    assign leaves[k] = 1'b0;
                end
            end
            for (k = 0; k < 8; k = k + 1) begin : first_level
                assign level1[k] = leaves[2*k] ^ leaves[2*k+1];
            end
            for (k = 0; k < 4; k = k + 1) begin : second_level
                assign level2[k] = level1[2*k] ^ level1[2*k+1];
            end
            for (k = 0; k < 2; k = k + 1) begin : third_level
                assign level3[k] = level2[2*k] ^ level2[2*k+1];
            end
            assign state_out[n] = level3[0] ^ level3[1];
        end
    endgenerate
endmodule
