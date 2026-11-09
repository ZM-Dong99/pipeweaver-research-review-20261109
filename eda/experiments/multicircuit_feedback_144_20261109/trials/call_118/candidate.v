module cmp_combine (
    input  eq_hi,
    input  gt_hi,
    input  eq_lo,
    input  gt_lo,
    output eq,
    output gt
);
    assign eq = eq_hi & eq_lo;
    assign gt = gt_hi | (eq_hi & gt_lo);
endmodule

module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [15:0] eq_bit;
    wire [15:0] gt_bit;
    wire [7:0] eq_1;
    wire [7:0] gt_1;
    wire [3:0] eq_2;
    wire [3:0] gt_2;
    wire [1:0] eq_3;
    wire [1:0] gt_3;
    wire eq_4;
    wire gt_4;

    assign eq_bit = ~(A ^ B);
    assign gt_bit = A & ~B;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_level_1
            cmp_combine u_cmp (
                .eq_hi(eq_bit[2*i+1]),
                .gt_hi(gt_bit[2*i+1]),
                .eq_lo(eq_bit[2*i]),
                .gt_lo(gt_bit[2*i]),
                .eq(eq_1[i]),
                .gt(gt_1[i])
            );
        end
        for (i = 0; i < 4; i = i + 1) begin : gen_level_2
            cmp_combine u_cmp (
                .eq_hi(eq_1[2*i+1]),
                .gt_hi(gt_1[2*i+1]),
                .eq_lo(eq_1[2*i]),
                .gt_lo(gt_1[2*i]),
                .eq(eq_2[i]),
                .gt(gt_2[i])
            );
        end
        for (i = 0; i < 2; i = i + 1) begin : gen_level_3
            cmp_combine u_cmp (
                .eq_hi(eq_2[2*i+1]),
                .gt_hi(gt_2[2*i+1]),
                .eq_lo(eq_2[2*i]),
                .gt_lo(gt_2[2*i]),
                .eq(eq_3[i]),
                .gt(gt_3[i])
            );
        end
    endgenerate

    cmp_combine u_level_4 (
        .eq_hi(eq_3[1]),
        .gt_hi(gt_3[1]),
        .eq_lo(eq_3[0]),
        .gt_lo(gt_3[0]),
        .eq(eq_4),
        .gt(gt_4)
    );

    assign eq = eq_4;
    assign gt = gt_4;
    assign lt = ~(gt_4 | eq_4);
endmodule
