module crc32_d8 (
    input  wire [7:0]  data_in,
    input  wire [31:0] state_in,
    output wire [7:0]  data_out,
    output wire [31:0] state_out
);
    // Combine the byte with the low state byte before the parity network.
    wire [7:0] q;
    assign q = data_in ^ state_in[7:0];

    // The shifted-out data is the sequence of feedback bits, not data_in.
    assign data_out = q ^ {q[2:0], 5'b00000};

    // Constant coefficient matrix for eight reflected Galois steps.
    // All loops in these functions are evaluated during elaboration.
    function automatic [7:0] coefficient_mask;
        input integer output_bit;
        reg [31:0] value;
        integer basis, step;
        begin
            coefficient_mask = 8'b0;
            for (basis = 0; basis < 8; basis = basis + 1) begin
                value = 32'h00000001 << basis;
                for (step = 0; step < 8; step = step + 1) begin
                    if (value[0])
                        value = (value >> 1) ^ 32'hedb88320;
                    else
                        value = value >> 1;
                end
                coefficient_mask[basis] = value[output_bit];
            end
        end
    endfunction

    function automatic integer population;
        input [7:0] mask;
        integer k;
        begin
            population = 0;
            for (k = 0; k < 8; k = k + 1)
                population = population + ((mask >> k) & 1);
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

    genvar b, j;
    generate
        for (b = 0; b < 32; b = b + 1) begin : output_parity
            localparam [7:0] MASK = coefficient_mask(b);
            localparam integer TERMS = population(MASK);
            wire [15:0] leaf;
            wire [7:0] level1;
            wire [3:0] level2;
            wire [1:0] level3;

            // Pack active operands, including the shifted state bit, into
            // a balanced tree. Zero leaves disappear during optimization.
            for (j = 0; j < 16; j = j + 1) begin : operands
                if (j < TERMS) begin : feedback_operand
                    localparam integer INDEX = selected_bit(MASK, j);
                    assign leaf[j] = q[INDEX];
                end else if ((j == TERMS) && (b < 24)) begin : state_operand
                    assign leaf[j] = state_in[b+8];
                end else begin : zero_operand
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
            assign state_out[b] = level3[0] ^ level3[1];
        end
    endgenerate
endmodule
