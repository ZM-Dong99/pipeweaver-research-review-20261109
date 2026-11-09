module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [3:0] block_eq;
    wire [3:0] block_gt;

    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : blocks
            assign block_eq[k] = (A[4*k +: 4] == B[4*k +: 4]);
            assign block_gt[k] = (A[4*k +: 4] > B[4*k +: 4]);
        end
    endgenerate

    assign eq = &block_eq;
    assign gt = block_gt[3] |
                (block_eq[3] & block_gt[2]) |
                (block_eq[3] & block_eq[2] & block_gt[1]) |
                (block_eq[3] & block_eq[2] & block_eq[1] & block_gt[0]);
    assign lt = ~(gt | eq);
endmodule
