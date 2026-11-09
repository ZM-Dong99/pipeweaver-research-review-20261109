module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [15:0] same;
    wire [3:0] group_eq;
    wire [3:0] group_gt;
    wire [3:0] group_lt;

    assign same = ~(A ^ B);

    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : compare_groups
            assign group_eq[k] = &same[4*k +: 4];
            assign group_gt[k] =
                (A[4*k+3] & ~B[4*k+3]) |
                (same[4*k+3] & A[4*k+2] & ~B[4*k+2]) |
                (same[4*k+3] & same[4*k+2] & A[4*k+1] & ~B[4*k+1]) |
                (same[4*k+3] & same[4*k+2] & same[4*k+1] & A[4*k] & ~B[4*k]);
            assign group_lt[k] = ~(group_gt[k] | group_eq[k]);
        end
    endgenerate

    assign eq = &group_eq;
    assign gt = group_gt[3] |
                (group_eq[3] & group_gt[2]) |
                (group_eq[3] & group_eq[2] & group_gt[1]) |
                (group_eq[3] & group_eq[2] & group_eq[1] & group_gt[0]);
    assign lt = group_lt[3] |
                (group_eq[3] & group_lt[2]) |
                (group_eq[3] & group_eq[2] & group_lt[1]) |
                (group_eq[3] & group_eq[2] & group_eq[1] & group_lt[0]);
endmodule
