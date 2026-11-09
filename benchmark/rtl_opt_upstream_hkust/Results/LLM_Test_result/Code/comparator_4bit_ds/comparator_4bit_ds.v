module comparator_4bit_ds (
    input [3:0] A, B,
    output eq, gt, lt
);
    wire [3:0] A_eq_B = A ~^ B;
    wire [3:0] A_gt_B = A & ~B;
    wire [3:0] A_lt_B = ~A & B;
    
    assign eq = &A_eq_B;
    assign gt = A_gt_B[3] | 
                (A_eq_B[3] & A_gt_B[2]) | 
                (A_eq_B[3] & A_eq_B[2] & A_gt_B[1]) | 
                (A_eq_B[3] & A_eq_B[2] & A_eq_B[1] & A_gt_B[0]);
    assign lt = A_lt_B[3] | 
                (A_eq_B[3] & A_lt_B[2]) | 
                (A_eq_B[3] & A_eq_B[2] & A_lt_B[1]) | 
                (A_eq_B[3] & A_eq_B[2] & A_eq_B[1] & A_lt_B[0]);
endmodule