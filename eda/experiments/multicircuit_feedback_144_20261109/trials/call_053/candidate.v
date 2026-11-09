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
    mul_subexpression_csa u2(s0, c0, row[6], s2, c2);
    mul_subexpression_csa u3(s1, c1, row[7], s3, c3);
    mul_subexpression_csa u4(s2, c2, s3, s4, c4);
    mul_subexpression_csa u5(s4, c4, c3, s5, c5);

    assign product = s5 + c5;
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
