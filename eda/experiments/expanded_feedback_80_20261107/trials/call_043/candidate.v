module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire do_add, do_sub_ab, do_sub_ba;
    wire do_or, do_and, do_xor, do_xnor;
    wire arithmetic_en, subtract;
    wire [63:0] x, y, p, g, arithmetic_result;
    wire [64:0] carry;
    wire [15:0] gp0, gg0;
    wire [15:0] gp1, gg1;
    wire [15:0] gp2, gg2;
    wire [15:0] gp3, gg3;
    wire [15:0] gp4, gg4;

    assign do_add    = (Oper == 3'b000);
    assign do_sub_ab = (Oper == 3'b001);
    assign do_sub_ba = (Oper == 3'b010);
    assign do_or     = (Oper == 3'b011);
    assign do_and    = (Oper == 3'b100);
    assign do_xor    = (Oper == 3'b101);
    assign do_xnor   = (Oper == 3'b110);
    assign arithmetic_en = do_add | do_sub_ab | do_sub_ba;
    assign subtract = do_sub_ab | do_sub_ba;

    assign x = a ^ {64{do_sub_ba}};
    assign y = b ^ {64{do_sub_ab}};
    assign p = x ^ y;
    assign g = x & y;
    assign carry[0] = subtract;
    assign arithmetic_result = p ^ carry[63:0];

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : groups
            assign gp0[k] = p[4*k+3] & p[4*k+2] &
                            p[4*k+1] & p[4*k];
            assign gg0[k] = g[4*k+3] |
                            (p[4*k+3] & g[4*k+2]) |
                            (p[4*k+3] & p[4*k+2] & g[4*k+1]) |
                            (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);

            assign carry[4*k+1] = g[4*k] |
                                     (p[4*k] & carry[4*k]);
            assign carry[4*k+2] = g[4*k+1] |
                                     (p[4*k+1] & g[4*k]) |
                                     (p[4*k+1] & p[4*k] & carry[4*k]);
            assign carry[4*k+3] = g[4*k+2] |
                                     (p[4*k+2] & g[4*k+1]) |
                                     (p[4*k+2] & p[4*k+1] & g[4*k]) |
                                     (p[4*k+2] & p[4*k+1] & p[4*k] & carry[4*k]);
            assign carry[4*k+4] = gg4[k] | (gp4[k] & subtract);
        end

        for (k = 0; k < 16; k = k + 1) begin : prefix
            if (k >= 1) begin : distance1
                assign gg1[k] = gg0[k] | (gp0[k] & gg0[k-1]);
                assign gp1[k] = gp0[k] & gp0[k-1];
            end else begin : pass1
                assign gg1[k] = gg0[k];
                assign gp1[k] = gp0[k];
            end
            if (k >= 2) begin : distance2
                assign gg2[k] = gg1[k] | (gp1[k] & gg1[k-2]);
                assign gp2[k] = gp1[k] & gp1[k-2];
            end else begin : pass2
                assign gg2[k] = gg1[k];
                assign gp2[k] = gp1[k];
            end
            if (k >= 4) begin : distance4
                assign gg3[k] = gg2[k] | (gp2[k] & gg2[k-4]);
                assign gp3[k] = gp2[k] & gp2[k-4];
            end else begin : pass4
                assign gg3[k] = gg2[k];
                assign gp3[k] = gp2[k];
            end
            if (k >= 8) begin : distance8
                assign gg4[k] = gg3[k] | (gp3[k] & gg3[k-8]);
                assign gp4[k] = gp3[k] & gp3[k-8];
            end else begin : pass8
                assign gg4[k] = gg3[k];
                assign gp4[k] = gp3[k];
            end
        end
    endgenerate

    always @(*) begin
        sum = ({64{arithmetic_en}} & arithmetic_result) |
              ({64{do_or}} & (a | b)) |
              ({64{do_and}} & (a & b)) |
              ({64{do_xor}} & (a ^ b)) |
              ({64{do_xnor}} & (a ~^ b));
    end
endmodule
