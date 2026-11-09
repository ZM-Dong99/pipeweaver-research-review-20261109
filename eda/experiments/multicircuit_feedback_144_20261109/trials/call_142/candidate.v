module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [15:0] same;
    wire [15:0] greater_bit;
    wire [3:0] group_equal;
    wire [3:0] group_greater;

    assign same = ~(A ^ B);
    assign greater_bit = A & ~B;

    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : compare_groups
            assign group_equal[k] = &same[4*k +: 4];
            assign group_greater[k] =
                greater_bit[4*k+3] |
                (same[4*k+3] & greater_bit[4*k+2]) |
                (same[4*k+3] & same[4*k+2] & greater_bit[4*k+1]) |
                (same[4*k+3] & same[4*k+2] & same[4*k+1] & greater_bit[4*k]);
        end
    endgenerate

    assign eq = &group_equal;
    assign gt = group_greater[3] |
                (group_equal[3] & group_greater[2]) |
                (group_equal[3] & group_equal[2] & group_greater[1]) |
                (group_equal[3] & group_equal[2] & group_equal[1] & group_greater[0]);
    assign lt = ~(gt | eq);
endmodule
