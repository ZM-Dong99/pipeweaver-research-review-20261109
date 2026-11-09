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

    wire [15:0] s10, c10, s11, c11;
    wire [15:0] s20, c20, s21, c21;
    wire [15:0] s30, c30;
    wire [15:0] x, y;

    mul_subexpression_csa16 u10(row[0], row[1], row[2], s10, c10);
    mul_subexpression_csa16 u11(row[3], row[4], row[5], s11, c11);
    mul_subexpression_csa16 u20(s10, c10, s11, s20, c20);
    mul_subexpression_csa16 u21(c11, row[6], row[7], s21, c21);
    mul_subexpression_csa16 u30(s20, c20, s21, s30, c30);
    mul_subexpression_csa16 u40(s30, c30, c21, x, y);

    wire [15:0] p, g;
    wire [3:0] gp, gg;
    wire [3:0] bc;
    wire [15:0] carry;
    assign p = x ^ y;
    assign g = x & y;

    genvar b;
    generate
        for (b = 0; b < 4; b = b + 1) begin: gen_groups
            assign gp[b] = p[4*b+3] & p[4*b+2] & p[4*b+1] & p[4*b];
            assign gg[b] = g[4*b+3]
                         | (p[4*b+3] & g[4*b+2])
                         | (p[4*b+3] & p[4*b+2] & g[4*b+1])
                         | (p[4*b+3] & p[4*b+2] & p[4*b+1] & g[4*b]);
            assign carry[4*b] = bc[b];
            assign carry[4*b+1] = g[4*b] | (p[4*b] & bc[b]);
            assign carry[4*b+2] = g[4*b+1]
                                | (p[4*b+1] & g[4*b])
                                | (p[4*b+1] & p[4*b] & bc[b]);
            assign carry[4*b+3] = g[4*b+2]
                                | (p[4*b+2] & g[4*b+1])
                                | (p[4*b+2] & p[4*b+1] & g[4*b])
                                | (p[4*b+2] & p[4*b+1] & p[4*b] & bc[b]);
        end
    endgenerate

    assign bc[0] = 1'b0;
    assign bc[1] = gg[0];
    assign bc[2] = gg[1] | (gp[1] & gg[0]);
    assign bc[3] = gg[2] | (gp[2] & gg[1]) | (gp[2] & gp[1] & gg[0]);
    assign product = p ^ carry;
endmodule

module mul_subexpression_csa16(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] s,
    output [15:0] carry
);
    assign s = a ^ b ^ c;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule
