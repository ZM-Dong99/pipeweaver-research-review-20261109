module comparator_node (
    input hi_gt,
    input hi_eq,
    input lo_gt,
    input lo_eq,
    output gt,
    output eq
);
    assign eq = hi_eq & lo_eq;
    assign gt = hi_gt | (hi_eq & lo_gt);
endmodule

module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [15:0] bit_gt;
    wire [15:0] bit_eq;

    assign bit_gt = A & ~B;
    assign bit_eq = ~(A ^ B);

    wire [7:0] gt_1;
    wire [7:0] eq_1;
    wire [3:0] gt_2;
    wire [3:0] eq_2;
    wire [1:0] gt_3;
    wire [1:0] eq_3;

    comparator_node n10 (bit_gt[1],  bit_eq[1],  bit_gt[0],  bit_eq[0],  gt_1[0], eq_1[0]);
    comparator_node n11 (bit_gt[3],  bit_eq[3],  bit_gt[2],  bit_eq[2],  gt_1[1], eq_1[1]);
    comparator_node n12 (bit_gt[5],  bit_eq[5],  bit_gt[4],  bit_eq[4],  gt_1[2], eq_1[2]);
    comparator_node n13 (bit_gt[7],  bit_eq[7],  bit_gt[6],  bit_eq[6],  gt_1[3], eq_1[3]);
    comparator_node n14 (bit_gt[9],  bit_eq[9],  bit_gt[8],  bit_eq[8],  gt_1[4], eq_1[4]);
    comparator_node n15 (bit_gt[11], bit_eq[11], bit_gt[10], bit_eq[10], gt_1[5], eq_1[5]);
    comparator_node n16 (bit_gt[13], bit_eq[13], bit_gt[12], bit_eq[12], gt_1[6], eq_1[6]);
    comparator_node n17 (bit_gt[15], bit_eq[15], bit_gt[14], bit_eq[14], gt_1[7], eq_1[7]);

    comparator_node n20 (gt_1[1], eq_1[1], gt_1[0], eq_1[0], gt_2[0], eq_2[0]);
    comparator_node n21 (gt_1[3], eq_1[3], gt_1[2], eq_1[2], gt_2[1], eq_2[1]);
    comparator_node n22 (gt_1[5], eq_1[5], gt_1[4], eq_1[4], gt_2[2], eq_2[2]);
    comparator_node n23 (gt_1[7], eq_1[7], gt_1[6], eq_1[6], gt_2[3], eq_2[3]);

    comparator_node n30 (gt_2[1], eq_2[1], gt_2[0], eq_2[0], gt_3[0], eq_3[0]);
    comparator_node n31 (gt_2[3], eq_2[3], gt_2[2], eq_2[2], gt_3[1], eq_3[1]);

    comparator_node n40 (gt_3[1], eq_3[1], gt_3[0], eq_3[0], gt, eq);

    assign lt = ~(gt | eq);
endmodule
