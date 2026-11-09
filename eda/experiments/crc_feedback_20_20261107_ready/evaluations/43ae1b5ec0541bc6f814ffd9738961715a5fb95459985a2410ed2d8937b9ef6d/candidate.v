module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Reflected CRC32 byte input, before feedback propagation.
    wire [7:0] t;
    assign t = data_in ^ state_in[7:0];

    // Compute constant coefficients of the eight-bit reflected update.
    // This function is evaluated only with constant arguments.
    function automatic [7:0] crc_mask;
        input integer output_bit;
        reg [31:0] v;
        integer k, j;
        begin
            crc_mask = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                v = 32'h00000001 << k;
                for (j = 0; j < 8; j = j + 1) begin
                    if (v[0])
                        v = (v >> 1) ^ 32'hedb88320;
                    else
                        v = v >> 1;
                end
                crc_mask[k] = v[output_bit];
            end
        end
    endfunction

    function automatic integer population;
        input [7:0] mask;
        integer k;
        begin
            population = 0;
            for (k = 0; k < 8; k = k + 1)
                if (mask[k]) population = population + 1;
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
                    if (count == ordinal) selected_bit = k;
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar b, k;
    generate
        for (b = 0; b < 32; b = b + 1) begin : output_bit
            localparam [7:0] MASK = crc_mask(b);
            localparam integer N = population(MASK);
            wire [31:1] tree;

            // Pack active operands together before balancing the XOR tree.
            // Include the untouched upper state operand in the same tree.
            for (k = 0; k < 16; k = k + 1) begin : leaf
                if (k < N) begin : feedback_term
                    localparam integer INDEX = selected_bit(MASK, k);
                    assign tree[16+k] = t[INDEX];
                end else if ((k == N) && (b < 24)) begin : shifted_state
                    assign tree[16+k] = state_in[b+8];
                end else begin : padding
                    assign tree[16+k] = 1'b0;
                end
            end
            for (k = 1; k < 16; k = k + 1) begin : branch
                assign tree[k] = tree[2*k] ^ tree[2*k+1];
            end
            assign state_out[b] = tree[1];
        end
    endgenerate

    // Feedback bits emitted by the original eight reflected shifts.
    assign data_out[5:0] = t[5:0];
    assign data_out[6] = t[6] ^ t[0];
    assign data_out[7] = t[7] ^ t[1];
endmodule
