module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [15:0] same;
    wire [15:0] greater;
    wire [15:0] less;
    wire [3:0] group_eq;
    wire [3:0] group_gt;
    wire [3:0] group_lt;

    assign same = ~(A ^ B);
    assign greater = A & ~B;
    assign less = ~A & B;

    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : groups
            assign group_eq[k] = &same[4*k +: 4];
            assign group_gt[k] = greater[4*k+3]
                | (same[4*k+3] & greater[4*k+2])
                | (same[4*k+3] & same[4*k+2] & greater[4*k+1])
                | (same[4*k+3] & same[4*k+2] & same[4*k+1] & greater[4*k]);
            assign group_lt[k] = less[4*k+3]
                | (same[4*k+3] & less[4*k+2])
                | (same[4*k+3] & same[4*k+2] & less[4*k+1])
                | (same[4*k+3] & same[4*k+2] & same[4*k+1] & less[4*k]);
        end
    endgenerate

    assign eq = &group_eq;
    assign gt = group_gt[3]
        | (group_eq[3] & group_gt[2])
        | (group_eq[3] & group_eq[2] & group_gt[1])
        | (group_eq[3] & group_eq[2] & group_eq[1] & group_gt[0]);
    assign lt = group_lt[3]
        | (group_eq[3] & group_lt[2])
        | (group_eq[3] & group_eq[2] & group_lt[1])
        | (group_eq[3] & group_eq[2] & group_eq[1] & group_lt[0]);
endmodule
