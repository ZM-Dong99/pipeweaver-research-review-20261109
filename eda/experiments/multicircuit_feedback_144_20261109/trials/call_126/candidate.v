module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);
    wire [15:0] pp [0:7];
    genvar r;
    generate
        for (r = 0; r < 8; r = r + 1) begin: partial_rows
            assign pp[r] = {8'b0, (multiplier & {8{multiplicand[r]}})} << r;
        end
    endgenerate

    wire [15:0] s0, c0, s1, c1;
    wire [15:0] s2, c2, s3, c3;
    wire [15:0] s4, c4, s5, c5;

    mul_subexpression_csa u0(pp[0], pp[1], pp[2], s0, c0);
    mul_subexpression_csa u1(pp[3], pp[4], pp[5], s1, c1);
    mul_subexpression_csa u2(s0, c0, s1, s2, c2);
    mul_subexpression_csa u3(c1, pp[6], pp[7], s3, c3);
    mul_subexpression_csa u4(s2, c2, s3, s4, c4);
    mul_subexpression_csa u5(s4, c4, c3, s5, c5);
    mul_subexpression_cla finish(s5, c5, product);
endmodule

module mul_subexpression_csa(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] s,
    output [15:0] carry
);
    wire [15:0] ab;
    assign ab = a ^ b;
    assign s = ab ^ c;
    assign carry = ((a & b) | (ab & c)) << 1;
endmodule

module mul_subexpression_cla(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [15:0] p, g;
    wire [3:0] bp, bg;
    wire [3:0] bc;
    assign p = a ^ b;
    assign g = a & b;

    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin: groups
            assign bp[k] = p[4*k+3] & p[4*k+2] & p[4*k+1] & p[4*k];
            assign bg[k] = g[4*k+3]
                         | (p[4*k+3] & g[4*k+2])
                         | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                         | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
        end
    endgenerate

    assign bc[0] = 1'b0;
    assign bc[1] = bg[0];
    assign bc[2] = bg[1] | (bp[1] & bg[0]);
    assign bc[3] = bg[2] | (bp[2] & bg[1])
                            | (bp[2] & bp[1] & bg[0]);

    generate
        for (k = 0; k < 4; k = k + 1) begin: sums
            wire c1, c2, c3;
            assign c1 = g[4*k] | (p[4*k] & bc[k]);
            assign c2 = g[4*k+1]
                      | (p[4*k+1] & g[4*k])
                      | (p[4*k+1] & p[4*k] & bc[k]);
            assign c3 = g[4*k+2]
                      | (p[4*k+2] & g[4*k+1])
                      | (p[4*k+2] & p[4*k+1] & g[4*k])
                      | (p[4*k+2] & p[4*k+1] & p[4*k] & bc[k]);
            assign sum[4*k] = p[4*k] ^ bc[k];
            assign sum[4*k+1] = p[4*k+1] ^ c1;
            assign sum[4*k+2] = p[4*k+2] ^ c2;
            assign sum[4*k+3] = p[4*k+3] ^ c3;
        end
    endgenerate
endmodule
