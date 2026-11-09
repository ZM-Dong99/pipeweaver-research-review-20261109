module comparator_2bit_ds (
    input [1:0] A, B,
    output eq, gt, lt
);
    wire [1:0] A_eq_B = A ^~ B;
    wire [1:0] A_gt_B = A & ~B;
    
    assign eq = &A_eq_B;
    assign gt = A_gt_B[1] | (A_eq_B[1] & A_gt_B[0]);
    assign lt = ~eq & ~gt;
endmodule