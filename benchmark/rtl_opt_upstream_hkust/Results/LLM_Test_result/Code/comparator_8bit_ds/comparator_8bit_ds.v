module comparator_8bit_ds (
    input [7:0] A, B,
    output eq, gt, lt
);
    wire [7:0] A_eq_B = A ~^ B;
    wire [7:0] A_gt_B = A & ~B;
    wire [7:0] A_lt_B = ~A & B;
    
    assign eq = &A_eq_B;
    assign gt = A_gt_B[7] |
               (A_eq_B[7] & A_gt_B[6]) |
               (&A_eq_B[7:6] & A_gt_B[5]) |
               (&A_eq_B[7:5] & A_gt_B[4]) |
               (&A_eq_B[7:4] & A_gt_B[3]) |
               (&A_eq_B[7:3] & A_gt_B[2]) |
               (&A_eq_B[7:2] & A_gt_B[1]) |
               (&A_eq_B[7:1] & A_gt_B[0]);
    assign lt = A_lt_B[7] |
               (A_eq_B[7] & A_lt_B[6]) |
               (&A_eq_B[7:6] & A_lt_B[5]) |
               (&A_eq_B[7:5] & A_lt_B[4]) |
               (&A_eq_B[7:4] & A_lt_B[3]) |
               (&A_eq_B[7:3] & A_lt_B[2]) |
               (&A_eq_B[7:2] & A_lt_B[1]) |
               (&A_eq_B[7:1] & A_lt_B[0]);
endmodule