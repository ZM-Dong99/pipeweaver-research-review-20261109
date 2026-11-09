module comparator_8bit_mini (
    input [7:0] A, B,
    output eq, gt, lt
);
    wire [7:0] xnor_out;
    wire [7:0] gt_bit;
    wire [7:0] lt_bit;
    wire [7:0] eq_prop;

    assign xnor_out = ~(A ^ B); // Bitwise equality
    assign gt_bit = A & ~B;   // A[i] > B[i] if A[i]=1 and B[i]=0
    assign lt_bit = ~A & B;   // A[i] < B[i] if A[i]=0 and B[i]=1

    assign eq_prop[7] = xnor_out[7];
    assign eq_prop[6] = xnor_out[6] & eq_prop[7];
    assign eq_prop[5] = xnor_out[5] & eq_prop[6];
    assign eq_prop[4] = xnor_out[4] & eq_prop[5];
    assign eq_prop[3] = xnor_out[3] & eq_prop[4];
    assign eq_prop[2] = xnor_out[2] & eq_prop[3];
    assign eq_prop[1] = xnor_out[1] & eq_prop[2];
    assign eq_prop[0] = xnor_out[0] & eq_prop[1];

    assign eq = eq_prop[0];

    assign gt = gt_bit[7] |
                (eq_prop[7] & gt_bit[6]) |
                (eq_prop[6] & gt_bit[5]) |
                (eq_prop[5] & gt_bit[4]) |
                (eq_prop[4] & gt_bit[3]) |
                (eq_prop[3] & gt_bit[2]) |
                (eq_prop[2] & gt_bit[1]) |
                (eq_prop[1] & gt_bit[0]);

    assign lt = lt_bit[7] |
                (eq_prop[7] & lt_bit[6]) |
                (eq_prop[6] & lt_bit[5]) |
                (eq_prop[5] & lt_bit[4]) |
                (eq_prop[4] & lt_bit[3]) |
                (eq_prop[3] & lt_bit[2]) |
                (eq_prop[2] & lt_bit[1]) |
                (eq_prop[1] & lt_bit[0]);

endmodule