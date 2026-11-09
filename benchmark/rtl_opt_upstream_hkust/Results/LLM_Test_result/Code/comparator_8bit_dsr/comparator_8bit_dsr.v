module comparator_8bit_dsr (
    input [7:0] A, B,
    output eq, gt, lt
);
    wire [7:0] eq_bits = A ~^ B;
    assign eq = &eq_bits;

    wire [7:0] gt_terms;
    wire [7:0] lt_terms;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_comp
            assign gt_terms[i] = (A[i] > B[i]) && (&eq_bits[7:i+1]);
            assign lt_terms[i] = (A[i] < B[i]) && (&eq_bits[7:i+1]);
        end
    endgenerate

    assign gt = |gt_terms;
    assign lt = |lt_terms;
endmodule