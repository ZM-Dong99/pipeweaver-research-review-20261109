module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [15:0] g0, l0;
    wire [7:0] g1, l1;
    wire [3:0] g2, l2;
    wire [1:0] g3, l3;

    assign g0 = A & ~B;
    assign l0 = B & ~A;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : compare_pairs
            assign g1[i] = g0[2*i+1] | (~l0[2*i+1] & g0[2*i]);
            assign l1[i] = l0[2*i+1] | (~g0[2*i+1] & l0[2*i]);
        end
        for (i = 0; i < 4; i = i + 1) begin : compare_quads
            assign g2[i] = g1[2*i+1] | (~l1[2*i+1] & g1[2*i]);
            assign l2[i] = l1[2*i+1] | (~g1[2*i+1] & l1[2*i]);
        end
        for (i = 0; i < 2; i = i + 1) begin : compare_octets
            assign g3[i] = g2[2*i+1] | (~l2[2*i+1] & g2[2*i]);
            assign l3[i] = l2[2*i+1] | (~g2[2*i+1] & l2[2*i]);
        end
    endgenerate

    assign gt = g3[1] | (~l3[1] & g3[0]);
    assign lt = l3[1] | (~g3[1] & l3[0]);
    assign eq = ~(g3[1] | l3[1] | g3[0] | l3[0]);
endmodule
