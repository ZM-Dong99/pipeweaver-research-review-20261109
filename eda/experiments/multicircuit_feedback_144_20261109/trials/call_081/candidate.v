module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);
    wire [15:0] row [0:7];
    genvar r;
    generate
        for (r = 0; r < 8; r = r + 1) begin: gen_rows
            assign row[r] = {8'b0, (multiplier & {8{multiplicand[r]}})} << r;
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

    wire [15:0] bit_p;
    wire [15:0] p [0:4];
    wire [15:0] g [0:4];
    assign bit_p = s5 ^ c5;
    assign p[0] = bit_p;
    assign g[0] = s5 & c5;

    genvar level, bit_index;
    generate
        for (level = 0; level < 4; level = level + 1) begin: gen_prefix_level
            for (bit_index = 0; bit_index < 16; bit_index = bit_index + 1) begin: gen_prefix_bit
                if (bit_index >= (1 << level)) begin: gen_combine
                    assign g[level+1][bit_index] = g[level][bit_index] |
                        (p[level][bit_index] & g[level][bit_index-(1 << level)]);
                    assign p[level+1][bit_index] = p[level][bit_index] &
                        p[level][bit_index-(1 << level)];
                end else begin: gen_pass
                    assign g[level+1][bit_index] = g[level][bit_index];
                    assign p[level+1][bit_index] = p[level][bit_index];
                end
            end
        end
    endgenerate

    assign product = bit_p ^ {g[4][14:0], 1'b0};
endmodule

module mul_subexpression_csa(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule
