module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);
    wire [15:0] bg, bl;
    wire [7:0] pg, pl;
    wire [3:0] qg, ql;
    wire [3:0] gp, lp;

    assign bg = A & ~B;
    assign bl = ~A & B;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pairs
            assign pg[i] = bg[2*i+1] | (~bl[2*i+1] & bg[2*i]);
            assign pl[i] = bl[2*i+1] | (~bg[2*i+1] & bl[2*i]);
        end
        for (i = 0; i < 4; i = i + 1) begin : quartets
            assign qg[i] = pg[2*i+1] | (~pl[2*i+1] & pg[2*i]);
            assign ql[i] = pl[2*i+1] | (~pg[2*i+1] & pl[2*i]);
        end
    endgenerate

    assign gp = ~ql;
    assign lp = ~qg;

    assign gt = qg[3]
              | (gp[3] & qg[2])
              | (gp[3] & gp[2] & qg[1])
              | (gp[3] & gp[2] & gp[1] & qg[0]);

    assign lt = ql[3]
              | (lp[3] & ql[2])
              | (lp[3] & lp[2] & ql[1])
              | (lp[3] & lp[2] & lp[1] & ql[0]);

    assign eq = ~(gt | lt);
endmodule
