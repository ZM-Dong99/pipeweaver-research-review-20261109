module comparator_2bit_gpt (
    input [1:0] A, B,
    output eq, gt, lt
);
    wire A1_eq_B1 = (A[1] == B[1]);
    wire A0_gt_B0 = (A[0] > B[0]);
    wire A0_lt_B0 = (A[0] < B[0]);
    
    assign eq = A1_eq_B1 && (A[0] == B[0]);
    assign gt = (A[1] > B[1]) || (A1_eq_B1 && A0_gt_B0);
    assign lt = (A[1] < B[1]) || (A1_eq_B1 && A0_lt_B0);
endmodule