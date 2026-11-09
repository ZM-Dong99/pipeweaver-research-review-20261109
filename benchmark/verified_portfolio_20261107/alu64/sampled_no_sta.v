module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire arithmetic_enable;
    wire or_enable, and_enable, xor_enable, xnor_enable;
    wire subtract;
    wire [63:0] axb;
    wire [63:0] x, y, p, g;
    wire [31:0] group_p [0:5];
    wire [31:0] group_g [0:5];
    wire [63:0] carry;
    wire [63:0] arithmetic_result;
    wire [63:0] logic_result;
    wire logic_equal_one_enable;
    wire logic_unequal_enable;

    assign arithmetic_enable = ~Oper[2] & ~(Oper[1] & Oper[0]);
    assign or_enable   = (Oper == 3'b011);
    assign and_enable  = (Oper == 3'b100);
    assign xor_enable  = (Oper == 3'b101);
    assign xnor_enable = (Oper == 3'b110);

    // For the three arithmetic operations, invert the subtrahend
    // and inject the two's-complement carry at bit zero.
    assign subtract = Oper[1] | Oper[0];
    assign axb = a ^ b;
    assign x = a ^ {64{Oper[1]}};
    assign y = b ^ {64{Oper[0]}};
    assign p = axb ^ {64{subtract}};
    assign g = x & y;

    // Two-bit groups followed by a parallel-prefix carry network.
    // The initial carry is absorbed into the first group generate.
    genvar k, s, j;
    generate
        for (k = 0; k < 32; k = k + 1) begin : make_groups
            assign group_p[0][k] = p[2*k+1] & p[2*k];
            if (k == 0) begin : first_group
                assign group_g[0][k] = g[1] |
                    (p[1] & (g[0] | (p[0] & subtract)));
            end else begin : other_group
                assign group_g[0][k] = g[2*k+1] |
                    (p[2*k+1] & g[2*k]);
            end
        end
        for (s = 0; s < 5; s = s + 1) begin : prefix_stage
            for (j = 0; j < 32; j = j + 1) begin : prefix_node
                if (j >= (1 << s)) begin : combine
                    assign group_g[s+1][j] = group_g[s][j] |
                        (group_p[s][j] & group_g[s][j-(1 << s)]);
                    assign group_p[s+1][j] = group_p[s][j] &
                        group_p[s][j-(1 << s)];
                end else begin : forward
                    assign group_g[s+1][j] = group_g[s][j];
                    assign group_p[s+1][j] = group_p[s][j];
                end
            end
        end
        for (k = 0; k < 32; k = k + 1) begin : finish_pairs
            if (k == 0) begin : initial_carry
                assign carry[2*k] = subtract;
            end else begin : prefix_carry
                assign carry[2*k] = group_g[5][k-1];
            end
            assign carry[2*k+1] = g[2*k] |
                (p[2*k] & carry[2*k]);
        end
    endgenerate

    // The least-significant result bit is identical for add and subtract.
    assign arithmetic_result[0] = axb[0];
    assign arithmetic_result[63:1] = p[63:1] ^ carry[63:1];

    // Factor the Boolean operations using equal/unequal operand bits.
    assign logic_equal_one_enable = or_enable | and_enable;
    assign logic_unequal_enable = or_enable | xor_enable;
    assign logic_result =
        ((a & b) & {64{logic_equal_one_enable}}) |
        (axb & {64{logic_unequal_enable}}) |
        ((~axb) & {64{xnor_enable}});

    always @(*) begin
        sum = (arithmetic_result & {64{arithmetic_enable}}) |
              logic_result;
    end
endmodule
