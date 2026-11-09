module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [7:0] g2;
    wire [7:0] e2;
    wire [7:0] l2;
    wire [3:0] g4;
    wire [3:0] e4;
    wire [3:0] l4;
    wire [1:0] g8;
    wire [1:0] e8;
    wire [1:0] l8;

    comparator_16bit_cmp2 c0 (.a(A[1:0]),   .b(B[1:0]),   .gt(g2[0]), .eq(e2[0]), .lt(l2[0]));
    comparator_16bit_cmp2 c1 (.a(A[3:2]),   .b(B[3:2]),   .gt(g2[1]), .eq(e2[1]), .lt(l2[1]));
    comparator_16bit_cmp2 c2 (.a(A[5:4]),   .b(B[5:4]),   .gt(g2[2]), .eq(e2[2]), .lt(l2[2]));
    comparator_16bit_cmp2 c3 (.a(A[7:6]),   .b(B[7:6]),   .gt(g2[3]), .eq(e2[3]), .lt(l2[3]));
    comparator_16bit_cmp2 c4 (.a(A[9:8]),   .b(B[9:8]),   .gt(g2[4]), .eq(e2[4]), .lt(l2[4]));
    comparator_16bit_cmp2 c5 (.a(A[11:10]), .b(B[11:10]), .gt(g2[5]), .eq(e2[5]), .lt(l2[5]));
    comparator_16bit_cmp2 c6 (.a(A[13:12]), .b(B[13:12]), .gt(g2[6]), .eq(e2[6]), .lt(l2[6]));
    comparator_16bit_cmp2 c7 (.a(A[15:14]), .b(B[15:14]), .gt(g2[7]), .eq(e2[7]), .lt(l2[7]));

    comparator_16bit_join j0 (.gh(g2[1]), .eh(e2[1]), .lh(l2[1]), .gl(g2[0]), .el(e2[0]), .ll(l2[0]), .gt(g4[0]), .eq(e4[0]), .lt(l4[0]));
    comparator_16bit_join j1 (.gh(g2[3]), .eh(e2[3]), .lh(l2[3]), .gl(g2[2]), .el(e2[2]), .ll(l2[2]), .gt(g4[1]), .eq(e4[1]), .lt(l4[1]));
    comparator_16bit_join j2 (.gh(g2[5]), .eh(e2[5]), .lh(l2[5]), .gl(g2[4]), .el(e2[4]), .ll(l2[4]), .gt(g4[2]), .eq(e4[2]), .lt(l4[2]));
    comparator_16bit_join j3 (.gh(g2[7]), .eh(e2[7]), .lh(l2[7]), .gl(g2[6]), .el(e2[6]), .ll(l2[6]), .gt(g4[3]), .eq(e4[3]), .lt(l4[3]));

    comparator_16bit_join j4 (.gh(g4[1]), .eh(e4[1]), .lh(l4[1]), .gl(g4[0]), .el(e4[0]), .ll(l4[0]), .gt(g8[0]), .eq(e8[0]), .lt(l8[0]));
    comparator_16bit_join j5 (.gh(g4[3]), .eh(e4[3]), .lh(l4[3]), .gl(g4[2]), .el(e4[2]), .ll(l4[2]), .gt(g8[1]), .eq(e8[1]), .lt(l8[1]));

    comparator_16bit_join j6 (.gh(g8[1]), .eh(e8[1]), .lh(l8[1]), .gl(g8[0]), .el(e8[0]), .ll(l8[0]), .gt(gt), .eq(eq), .lt(lt));
endmodule

module comparator_16bit_cmp2 (
    input [1:0] a,
    input [1:0] b,
    output gt,
    output eq,
    output lt
);
    wire e1;
    wire e0;
    assign e1 = ~(a[1] ^ b[1]);
    assign e0 = ~(a[0] ^ b[0]);
    assign eq = e1 & e0;
    assign gt = (a[1] & ~b[1]) | (e1 & a[0] & ~b[0]);
    assign lt = (~a[1] & b[1]) | (e1 & ~a[0] & b[0]);
endmodule

module comparator_16bit_join (
    input gh,
    input eh,
    input lh,
    input gl,
    input el,
    input ll,
    output gt,
    output eq,
    output lt
);
    assign eq = eh & el;
    assign gt = gh | (eh & gl);
    assign lt = lh | (eh & ll);
endmodule
