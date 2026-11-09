module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire e0, e1, e2, e3, e4, e5, e6, e7;
    wire e8, e9, e10, e11, e12, e13, e14, e15;
    wire g0, g1, g2, g3, g4, g5, g6, g7;
    wire g8, g9, g10, g11, g12, g13, g14, g15;
    wire e1_0, e3_2, e5_4, e7_6, e9_8, e11_10, e13_12, e15_14;
    wire g1_0, g3_2, g5_4, g7_6, g9_8, g11_10, g13_12, g15_14;
    wire e3_0, e7_4, e11_8, e15_12;
    wire g3_0, g7_4, g11_8, g15_12;
    wire e7_0, e15_8;
    wire g7_0, g15_8;
    wire e15_0, g15_0;

    assign e0  = ~(A[0]  ^ B[0]);
    assign e1  = ~(A[1]  ^ B[1]);
    assign e2  = ~(A[2]  ^ B[2]);
    assign e3  = ~(A[3]  ^ B[3]);
    assign e4  = ~(A[4]  ^ B[4]);
    assign e5  = ~(A[5]  ^ B[5]);
    assign e6  = ~(A[6]  ^ B[6]);
    assign e7  = ~(A[7]  ^ B[7]);
    assign e8  = ~(A[8]  ^ B[8]);
    assign e9  = ~(A[9]  ^ B[9]);
    assign e10 = ~(A[10] ^ B[10]);
    assign e11 = ~(A[11] ^ B[11]);
    assign e12 = ~(A[12] ^ B[12]);
    assign e13 = ~(A[13] ^ B[13]);
    assign e14 = ~(A[14] ^ B[14]);
    assign e15 = ~(A[15] ^ B[15]);

    assign g0  = A[0]  & ~B[0];
    assign g1  = A[1]  & ~B[1];
    assign g2  = A[2]  & ~B[2];
    assign g3  = A[3]  & ~B[3];
    assign g4  = A[4]  & ~B[4];
    assign g5  = A[5]  & ~B[5];
    assign g6  = A[6]  & ~B[6];
    assign g7  = A[7]  & ~B[7];
    assign g8  = A[8]  & ~B[8];
    assign g9  = A[9]  & ~B[9];
    assign g10 = A[10] & ~B[10];
    assign g11 = A[11] & ~B[11];
    assign g12 = A[12] & ~B[12];
    assign g13 = A[13] & ~B[13];
    assign g14 = A[14] & ~B[14];
    assign g15 = A[15] & ~B[15];

    assign e1_0  = e1 & e0;
    assign e3_2  = e3 & e2;
    assign e5_4  = e5 & e4;
    assign e7_6  = e7 & e6;
    assign e9_8  = e9 & e8;
    assign e11_10 = e11 & e10;
    assign e13_12 = e13 & e12;
    assign e15_14 = e15 & e14;

    assign g1_0  = g1 | (e1 & g0);
    assign g3_2  = g3 | (e3 & g2);
    assign g5_4  = g5 | (e5 & g4);
    assign g7_6  = g7 | (e7 & g6);
    assign g9_8  = g9 | (e9 & g8);
    assign g11_10 = g11 | (e11 & g10);
    assign g13_12 = g13 | (e13 & g12);
    assign g15_14 = g15 | (e15 & g14);

    assign e3_0  = e3_2 & e1_0;
    assign e7_4  = e7_6 & e5_4;
    assign e11_8 = e11_10 & e9_8;
    assign e15_12 = e15_14 & e13_12;

    assign g3_0  = g3_2 | (e3_2 & g1_0);
    assign g7_4  = g7_6 | (e7_6 & g5_4);
    assign g11_8 = g11_10 | (e11_10 & g9_8);
    assign g15_12 = g15_14 | (e15_14 & g13_12);

    assign e7_0  = e7_4 & e3_0;
    assign e15_8 = e15_12 & e11_8;
    assign g7_0  = g7_4 | (e7_4 & g3_0);
    assign g15_8 = g15_12 | (e15_12 & g11_8);

    assign e15_0 = e15_8 & e7_0;
    assign g15_0 = g15_8 | (e15_8 & g7_0);

    assign eq = e15_0;
    assign gt = g15_0;
    assign lt = ~(g15_0 | e15_0);
endmodule
