module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [3:0] group_eq;
    wire [3:0] group_gt;

    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : compare_groups
            assign group_eq[k] = (A[4*k +: 4] == B[4*k +: 4]);
            assign group_gt[k] = (A[4*k +: 4] > B[4*k +: 4]);
        end
    endgenerate

    assign eq = &group_eq;
    assign gt = group_gt[3]
              | (group_eq[3] & group_gt[2])
              | (group_eq[3] & group_eq[2] & group_gt[1])
              | (group_eq[3] & group_eq[2] & group_eq[1] & group_gt[0]);
    assign lt = ~(gt | eq);
endmodule
