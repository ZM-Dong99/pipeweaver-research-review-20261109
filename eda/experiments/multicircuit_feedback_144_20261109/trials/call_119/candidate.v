module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);
    wire [15:0] row [0:7];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: gen_rows
            assign row[i] = {8'b0, (multiplier & {8{multiplicand[i]}})} << i;
        end
    endgenerate

    wire [15:0] s0, c0, s1, c1;
    wire [15:0] s2, c2, s3, c3;
    wire [15:0] s4, c4, s5, c5;

    mul_subexpression_csa u0(row[0], row[1], row[2], s0, c0);
    mul_subexpression_csa u1(row[3], row[4], row[5], s1, c1);
    mul_subexpression_csa u2(s0, c0, s1, s2, c2);
    mul_subexpression_csa u3(c1, row[6], row[7], s3, c3);
    mul_subexpression_csa u4(s2, c2, s3, s4, c4);
    mul_subexpression_csa u5(s4, c4, c3, s5, c5);

    wire [15:0] p [0:4];
    wire [15:0] g [0:4];
    assign p[0] = s5 ^ c5;
    assign g[0] = s5 & c5;

    genvar level, bit_index;
    generate
        for (level = 0; level < 4; level = level + 1) begin: gen_prefix_level
            for (bit_index = 0; bit_index < 16; bit_index = bit_index + 1) begin: gen_prefix_bit
                if (bit_index >= (1 << level)) begin: gen_combine
                    assign p[level+1][bit_index] = p[level][bit_index] & p[level][bit_index-(1 << level)];
                    assign g[level+1][bit_index] = g[level][bit_index] |
                        (p[level][bit_index] & g[level][bit_index-(1 << level)]);
                end else begin: gen_pass
                    assign p[level+1][bit_index] = p[level][bit_index];
                    assign g[level+1][bit_index] = g[level][bit_index];
                end
            end
        end
    endgenerate

    assign product = p[0] ^ {g[4][14:0], 1'b0};
endmodule

module mul_subexpression_csa(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    wire [15:0] ab_xor;
    wire [15:0] majority;
    assign ab_xor = a ^ b;
    assign sum = ab_xor ^ c;
    assign majority = (a & b) | (ab_xor & c);
    assign carry = {majority[14:0], 1'b0};
endmodule
