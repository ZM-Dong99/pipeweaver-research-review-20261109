module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);
    wire [15:0] row [0:7];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: partial_rows
            assign row[i] = {8'b0, (multiplier & {8{multiplicand[i]}})} << i;
        end
    endgenerate

    wire [15:0] s0, c0, s1, c1;
    wire [15:0] s2, c2, s3, c3;
    wire [15:0] s4, c4, s5, c5;
    mul_subexpression_csa a0(row[0], row[1], row[2], s0, c0);
    mul_subexpression_csa a1(row[3], row[4], row[5], s1, c1);
    mul_subexpression_csa a2(s0, c0, s1, s2, c2);
    mul_subexpression_csa a3(c1, row[6], row[7], s3, c3);
    mul_subexpression_csa a4(s2, c2, s3, s4, c4);
    mul_subexpression_csa a5(s4, c4, c3, s5, c5);
    mul_subexpression_cla finish(s5, c5, product);
endmodule

module mul_subexpression_csa(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] s,
    output [15:0] carry
);
    assign s = a ^ b ^ c;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule

module mul_subexpression_cla(
    input [15:0] a,
    input [15:0] b,
    output [15:0] result
);
    wire [15:0] p, g;
    wire [3:0] gp, gg;
    wire [4:0] boundary;
    wire [15:0] carry;
    assign p = a ^ b;
    assign g = a & b;
    assign boundary[0] = 1'b0;
    assign boundary[1] = gg[0];
    assign boundary[2] = gg[1] | (gp[1] & gg[0]);
    assign boundary[3] = gg[2] | (gp[2] & gg[1]) | (gp[2] & gp[1] & gg[0]);
    assign boundary[4] = gg[3] | (gp[3] & gg[2]) | (gp[3] & gp[2] & gg[1]) | (gp[3] & gp[2] & gp[1] & gg[0]);
    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin: groups
            assign gp[k] = &p[4*k +: 4];
            assign gg[k] = g[4*k+3]
                         | (p[4*k+3] & g[4*k+2])
                         | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                         | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
            assign carry[4*k] = boundary[k];
            assign carry[4*k+1] = g[4*k] | (p[4*k] & boundary[k]);
            assign carry[4*k+2] = g[4*k+1]
                               | (p[4*k+1] & g[4*k])
                               | (p[4*k+1] & p[4*k] & boundary[k]);
            assign carry[4*k+3] = g[4*k+2]
                               | (p[4*k+2] & g[4*k+1])
                               | (p[4*k+2] & p[4*k+1] & g[4*k])
                               | (p[4*k+2] & p[4*k+1] & p[4*k] & boundary[k]);
        end
    endgenerate
    assign result = p ^ carry;
endmodule
