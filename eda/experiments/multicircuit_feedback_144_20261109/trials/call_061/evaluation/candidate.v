`default_nettype none
module crc32_d8 (
    input wire [7:0] data_in,
    input wire [31:0] state_in,
    output wire [7:0] data_out,
    output wire [31:0] state_out
);
    // Pair input data with the corresponding arbitrary CRC state bits.
    wire [7:0] t;
    assign t = data_in ^ state_in[7:0];

    // Constant elaboration of the reflected byte transform.  Bits 32..39
    // contain the successive feedback values, not the original input byte.
    function [7:0] transform_mask;
        input integer output_index;
        reg [31:0] s;
        reg [39:0] result_bits;
        reg feedback;
        integer k, j;
        begin
            transform_mask = 8'b0;
            for (k = 0; k < 8; k = k + 1) begin
                s = 32'b1 << k;
                result_bits = 40'b0;
                for (j = 0; j < 8; j = j + 1) begin
                    feedback = s[0];
                    result_bits[32+j] = feedback;
                    s = (s >> 1) ^ (feedback ? 32'hedb88320 : 32'b0);
                end
                result_bits[31:0] = s;
                transform_mask[k] = result_bits[output_index];
            end
        end
    endfunction

    function integer population;
        input [8:0] mask;
        integer k;
        begin
            population = 0;
            for (k = 0; k < 9; k = k + 1)
                population = population + mask[k];
        end
    endfunction

    function integer next_power_two;
        input integer value;
        integer p;
        begin
            p = 1;
            while (p < value)
                p = p * 2;
            next_power_two = p;
        end
    endfunction

    function integer selected_index;
        input [8:0] mask;
        input integer ordinal;
        integer k, count;
        begin
            selected_index = 0;
            count = 0;
            for (k = 0; k < 9; k = k + 1) begin
                if (mask[k]) begin
                    if (count == ordinal)
                        selected_index = k;
                    count = count + 1;
                end
            end
        end
    endfunction

    wire [39:0] result;
    genvar n, j;
    generate
        for (n = 0; n < 40; n = n + 1) begin : output_bit
            localparam [7:0] TM = transform_mask(n);
            localparam [8:0] MASK = { (n < 24), TM };
            localparam integer COUNT = population(MASK);
            localparam integer P = next_power_two(COUNT);
            wire [8:0] operands;
            wire [2*P-1:1] tree;
            assign operands[7:0] = t;
            if (n < 24) begin : shifted_state
                assign operands[8] = state_in[n+8];
            end else begin : no_shifted_state
                assign operands[8] = 1'b0;
            end
            for (j = 0; j < P; j = j + 1) begin : leaf
                if (j < COUNT) begin : selected
                    assign tree[P+j] = operands[selected_index(MASK, j)];
                end else begin : padding
                    assign tree[P+j] = 1'b0;
                end
            end
            for (j = 1; j < P; j = j + 1) begin : branch
                assign tree[j] = tree[2*j] ^ tree[2*j+1];
            end
            assign result[n] = tree[1];
        end
    endgenerate
    assign state_out = result[31:0];
    assign data_out = result[39:32];
endmodule
`default_nettype wire
