module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Combine corresponding data and state bits before the CRC transform.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // Constant coefficient matrix for the fixed reflected byte transform.
    // Outputs 32 through 39 are the eight chronological feedback bits.
    function automatic [7:0] coefficient_mask(input integer output_index);
        reg [31:0] v;
        reg [7:0] feedback_byte;
        reg feedback;
        integer basis_bit;
        integer step;
        begin
            coefficient_mask = 8'b0;
            for (basis_bit = 0; basis_bit < 8; basis_bit = basis_bit + 1) begin
                v = 32'b0;
                feedback_byte = 8'b0;
                feedback = 1'b0;
                for (step = 0; step < 8; step = step + 1) begin
                    feedback = v[0] ^ (step == basis_bit);
                    feedback_byte[step] = feedback;
                    v = (v >> 1) ^ (feedback ? 32'hedb88320 : 32'b0);
                end
                if (output_index < 32)
                    coefficient_mask[basis_bit] = v[output_index];
                else
                    coefficient_mask[basis_bit] = feedback_byte[output_index-32];
            end
        end
    endfunction

    function automatic integer population(input [7:0] mask);
        integer k;
        begin
            population = 0;
            for (k = 0; k < 8; k = k + 1)
                population = population + mask[k];
        end
    endfunction

    function automatic integer selected_bit(
        input [7:0] mask,
        input integer ordinal
    );
        integer k;
        integer rank;
        begin
            selected_bit = -1;
            rank = 0;
            for (k = 0; k < 8; k = k + 1) begin
                if (mask[k]) begin
                    if (rank == ordinal)
                        selected_bit = k;
                    rank = rank + 1;
                end
            end
        end
    endfunction

    genvar n, j;
    generate
        for (n = 0; n < 40; n = n + 1) begin : output_equation
            localparam [7:0] MASK = coefficient_mask(n);
            localparam integer TERMS = population(MASK);
            wire [15:0] leaf;
            wire [7:0] level1;
            wire [3:0] level2;
            wire [1:0] level3;
            wire result;

            // Pack only participating signals into a balanced XOR tree.
            // Include the shifted state bit in that same tree, rather than
            // adding another XOR after the completed CRC contribution.
            for (j = 0; j < 16; j = j + 1) begin : tree_leaf
                localparam integer BIT_INDEX = selected_bit(MASK, j);
                if (BIT_INDEX >= 0) begin : crc_term
                    assign leaf[j] = q[BIT_INDEX];
                end else if ((n < 24) && (j == TERMS)) begin : shifted_state
                    assign leaf[j] = state_in[n+8];
                end else begin : padding
                    assign leaf[j] = 1'b0;
                end
            end
            for (j = 0; j < 8; j = j + 1) begin : first_level
                assign level1[j] = leaf[2*j] ^ leaf[2*j+1];
            end
            for (j = 0; j < 4; j = j + 1) begin : second_level
                assign level2[j] = level1[2*j] ^ level1[2*j+1];
            end
            for (j = 0; j < 2; j = j + 1) begin : third_level
                assign level3[j] = level2[2*j] ^ level2[2*j+1];
            end
            assign result = level3[0] ^ level3[1];

            if (n < 32) begin : state_result
                assign state_out[n] = result;
            end else begin : data_result
                assign data_out[n-32] = result;
            end
        end
    endgenerate
endmodule
