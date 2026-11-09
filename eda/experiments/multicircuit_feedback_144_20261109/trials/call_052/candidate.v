module cmp1(input a, input b, output gt, output eq);
    assign gt = a & ~b;
    assign eq = ~(a ^ b);
endmodule

module cmp2(input [1:0] A, input [1:0] B, output gt, output eq);
    wire gt_hi, eq_hi, gt_lo, eq_lo;
    cmp1 u_hi(A[1], B[1], gt_hi, eq_hi);
    cmp1 u_lo(A[0], B[0], gt_lo, eq_lo);
    assign gt = gt_hi | (eq_hi & gt_lo);
    assign eq = eq_hi & eq_lo;
endmodule

module cmp4(input [3:0] A, input [3:0] B, output gt, output eq);
    wire gt_hi, eq_hi, gt_lo, eq_lo;
    cmp2 u_hi(A[3:2], B[3:2], gt_hi, eq_hi);
    cmp2 u_lo(A[1:0], B[1:0], gt_lo, eq_lo);
    assign gt = gt_hi | (eq_hi & gt_lo);
    assign eq = eq_hi & eq_lo;
endmodule

module cmp8(input [7:0] A, input [7:0] B, output gt, output eq);
    wire gt_hi, eq_hi, gt_lo, eq_lo;
    cmp4 u_hi(A[7:4], B[7:4], gt_hi, eq_hi);
    cmp4 u_lo(A[3:0], B[3:0], gt_lo, eq_lo);
    assign gt = gt_hi | (eq_hi & gt_lo);
    assign eq = eq_hi & eq_lo;
endmodule

module cmp16(input [15:0] A, input [15:0] B, output gt, output eq);
    wire gt_hi, eq_hi, gt_lo, eq_lo;
    cmp8 u_hi(A[15:8], B[15:8], gt_hi, eq_hi);
    cmp8 u_lo(A[7:0], B[7:0], gt_lo, eq_lo);
    assign gt = gt_hi | (eq_hi & gt_lo);
    assign eq = eq_hi & eq_lo;
endmodule

module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire cmp_gt, cmp_eq;
    cmp16 u_cmp(A, B, cmp_gt, cmp_eq);
    assign gt = cmp_gt;
    assign eq = cmp_eq;
    assign lt = ~(cmp_gt | cmp_eq);
endmodule
