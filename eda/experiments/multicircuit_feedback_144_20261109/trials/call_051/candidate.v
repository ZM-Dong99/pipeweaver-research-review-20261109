module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [15:0] bit_gt;
    wire [15:0] bit_lt;
    wire [3:0] group_gt;
    wire [3:0] group_lt;
    wire [3:0] group_eq;

    assign bit_gt = A & ~B;
    assign bit_lt = ~A & B;

    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : groups
            wire [3:0] g;
            wire [3:0] l;
            wire [3:0] pg;
            wire [3:0] pl;
            assign g = bit_gt[4*k +: 4];
            assign l = bit_lt[4*k +: 4];
            assign pg = ~l;
            assign pl = ~g;

            assign group_gt[k] = g[3]
                               | (pg[3] & g[2])
                               | (pg[3] & pg[2] & g[1])
                               | (pg[3] & pg[2] & pg[1] & g[0]);
            assign group_lt[k] = l[3]
                               | (pl[3] & l[2])
                               | (pl[3] & pl[2] & l[1])
                               | (pl[3] & pl[2] & pl[1] & l[0]);
            assign group_eq[k] = ~(group_gt[k] | group_lt[k]);
        end
    endgenerate

    assign gt = group_gt[3]
              | (group_eq[3] & group_gt[2])
              | (group_eq[3] & group_eq[2] & group_gt[1])
              | (group_eq[3] & group_eq[2] & group_eq[1] & group_gt[0]);
    assign lt = group_lt[3]
              | (group_eq[3] & group_lt[2])
              | (group_eq[3] & group_eq[2] & group_lt[1])
              | (group_eq[3] & group_eq[2] & group_eq[1] & group_lt[0]);
    assign eq = &group_eq;
endmodule
