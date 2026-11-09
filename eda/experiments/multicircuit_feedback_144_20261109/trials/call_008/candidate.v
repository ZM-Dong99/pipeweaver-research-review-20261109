module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [7:0] e0, g0, l0;
    wire [3:0] e1, g1, l1;
    wire [1:0] e2, g2, l2;
    wire e3, g3, l3;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_pairs
            assign e0[i] = (A[2*i+1] ~^ B[2*i+1]) & (A[2*i] ~^ B[2*i]);
            assign g0[i] = (A[2*i+1] & ~B[2*i+1]) |
                          ((A[2*i+1] ~^ B[2*i+1]) & A[2*i] & ~B[2*i]);
            assign l0[i] = (~A[2*i+1] & B[2*i+1]) |
                          ((A[2*i+1] ~^ B[2*i+1]) & ~A[2*i] & B[2*i]);
        end
        for (i = 0; i < 4; i = i + 1) begin : pair_groups
            assign e1[i] = e0[2*i+1] & e0[2*i];
            assign g1[i] = g0[2*i+1] | (e0[2*i+1] & g0[2*i]);
            assign l1[i] = l0[2*i+1] | (e0[2*i+1] & l0[2*i]);
        end
        for (i = 0; i < 2; i = i + 1) begin : group_pairs
            assign e2[i] = e1[2*i+1] & e1[2*i];
            assign g2[i] = g1[2*i+1] | (e1[2*i+1] & g1[2*i]);
            assign l2[i] = l1[2*i+1] | (e1[2*i+1] & l1[2*i]);
        end
    endgenerate
    assign e3 = e2[1] & e2[0];
    assign g3 = g2[1] | (e2[1] & g2[0]);
    assign l3 = l2[1] | (e2[1] & l2[0]);
    assign gt = g3;
    assign eq = e3;
    assign lt = l3;
endmodule
