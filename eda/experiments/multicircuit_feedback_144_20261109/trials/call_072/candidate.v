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
    wire [15:0] s30, c30, s40, c40;

    mul_subexpression_csa u10(row[0], row[1], row[2], s10, c10);
    mul_subexpression_csa u11(row[3], row[4], row[5], s11, c11);
    mul_subexpression_csa u20(s10, c10, s11, s20, c20);
    mul_subexpression_csa u21(c11, row[6], row[7], s21, c21);
    mul_subexpression_csa u30(s20, c20, s21, s30, c30);
    mul_subexpression_csa u40(s30, c30, c21, s40, c40);

    mul_subexpression_prefix_add u_final(s40, c40, product);
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

module mul_subexpression_prefix_add(
    input [15:0] a,
    input [15:0] b,
    output [15:0] s
);
    wire [15:0] p0, g0;
    wire [15:0] p1, g1;
    wire [15:0] p2, g2;
    wire [15:0] p3, g3;
    wire [15:0] p4, g4;
    assign p0 = a ^ b;
    assign g0 = a & b;

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin: prefix
            if (k >= 1) begin: level1
                assign p1[k] = p0[k] & p0[k-1];
                assign g1[k] = g0[k] | (p0[k] & g0[k-1]);
            end else begin: pass1
                assign p1[k] = p0[k];
                assign g1[k] = g0[k];
            end
            if (k >= 2) begin: level2
                assign p2[k] = p1[k] & p1[k-2];
                assign g2[k] = g1[k] | (p1[k] & g1[k-2]);
            end else begin: pass2
                assign p2[k] = p1[k];
                assign g2[k] = g1[k];
            end
            if (k >= 4) begin: level3
                assign p3[k] = p2[k] & p2[k-4];
                assign g3[k] = g2[k] | (p2[k] & g2[k-4]);
            end else begin: pass3
                assign p3[k] = p2[k];
                assign g3[k] = g2[k];
            end
            if (k >= 8) begin: level4
                assign p4[k] = p3[k] & p3[k-8];
                assign g4[k] = g3[k] | (p3[k] & g3[k-8]);
            end else begin: pass4
                assign p4[k] = p3[k];
                assign g4[k] = g3[k];
            end
        end
    endgenerate
    assign s = p0 ^ {g4[14:0], 1'b0};
endmodule
