`default_nettype none
module crc32_d8 (
    input  wire [7:0] data_in,
    input  wire [31:0] state_in,
    output wire [7:0] data_out,
    output wire [31:0] state_out
);
    // Factor the byte-wide input/state XOR before the CRC matrix.
    wire [7:0] e;
    assign e = data_in ^ state_in[7:0];

    // A column of the reflected, eight-step CRC transformation.
    // Indices 0..31 select next-state bits; 32..39 select the
    // feedback bits emitted in chronological (LSB-first) order.
    function [7:0] transform_mask;
        input integer index;
        reg [31:0] s;
        reg [7:0] feedback;
        integer column;
        integer step;
        begin
            transform_mask = 8'b0;
            for (column = 0; column < 8; column = column + 1) begin
                s = 32'b1 << column;
                feedback = 8'b0;
                for (step = 0; step < 8; step = step + 1) begin
                    feedback[step] = s[0];
                    if (s[0])
                        s = (s >> 1) ^ 32'hedb88320;
                    else
                        s = s >> 1;
                end
                if (index < 32)
                    transform_mask[column] = s[index];
                else
                    transform_mask[column] = feedback[index-32];
            end
        end
    endfunction

    function integer population;
        input [7:0] mask;
        integer k;
        begin
            population = 0;
            for (k = 0; k < 8; k = k + 1)
                population = population + mask[k];
        end
    endfunction

    function integer selected_index;
        input [7:0] mask;
        input integer ordinal;
        integer k;
        integer count;
        begin
            selected_index = 0;
            count = 0;
            for (k = 0; k < 8; k = k + 1) begin
                if (mask[k]) begin
                    if (count == ordinal)
                        selected_index = k;
                    count = count + 1;
                end
            end
        end
    endfunction

    genvar bit_index;
    genvar term_index;
    generate
        for (bit_index = 0; bit_index < 32; bit_index = bit_index + 1) begin : state_bits
            localparam [7:0] MASK = transform_mask(bit_index);
            localparam integer TERMS = population(MASK);
            if (bit_index < 24) begin : with_shifted_state
                wire [TERMS:0] leaves;
                assign leaves[TERMS] = state_in[bit_index+8];
                for (term_index = 0; term_index < TERMS; term_index = term_index + 1) begin : terms
                    assign leaves[term_index] = e[selected_index(MASK, term_index)];
                end
                assign state_out[bit_index] = ^leaves;
            end else begin : without_shifted_state
                if (TERMS == 0) begin : zero_result
                    assign state_out[bit_index] = 1'b0;
                end else begin : parity_result
                    wire [TERMS-1:0] leaves;
                    for (term_index = 0; term_index < TERMS; term_index = term_index + 1) begin : terms
                        assign leaves[term_index] = e[selected_index(MASK, term_index)];
                    end
                    assign state_out[bit_index] = ^leaves;
                end
            end
        end
        for (bit_index = 0; bit_index < 8; bit_index = bit_index + 1) begin : data_bits
            localparam [7:0] MASK = transform_mask(32+bit_index);
            localparam integer TERMS = population(MASK);
            if (TERMS == 0) begin : zero_result
                assign data_out[bit_index] = 1'b0;
            end else begin : parity_result
                wire [TERMS-1:0] leaves;
                for (term_index = 0; term_index < TERMS; term_index = term_index + 1) begin : terms
                    assign leaves[term_index] = e[selected_index(MASK, term_index)];
                end
                assign data_out[bit_index] = ^leaves;
            end
        end
    endgenerate
endmodule
`default_nettype wire
