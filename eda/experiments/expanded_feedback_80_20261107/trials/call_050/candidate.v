module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] px, pn;
    wire [63:0] g_add, g_ab, g_ba;
    wire [63:0] s_add, s_ab, s_ba;
    wire co_add, co_ab, co_ba;
    reg c_out;

    assign px = a ^ b;
    assign pn = ~px;
    assign g_add = a & b;
    assign g_ab = a & ~b;
    assign g_ba = b & ~a;

    alu64_sparse_carry u_add (
        .p(px), .g(g_add), .ci(1'b0), .s(s_add), .co(co_add)
    );
    alu64_sparse_carry u_ab (
        .p(pn), .g(g_ab), .ci(1'b1), .s(s_ab), .co(co_ab)
    );
    alu64_sparse_carry u_ba (
        .p(pn), .g(g_ba), .ci(1'b1), .s(s_ba), .co(co_ba)
    );

    always @(*) begin
        case (Oper)
            3'b000: {c_out, sum} = {co_add, s_add};
            3'b001: {c_out, sum} = {~co_ab, s_ab};
            3'b010: {c_out, sum} = {~co_ba, s_ba};
            3'b011: {c_out, sum} = {1'b0, (a | b)};
            3'b100: {c_out, sum} = {1'b0, (a & b)};
            3'b101: {c_out, sum} = {1'b0, px};
            3'b110: {c_out, sum} = {1'b0, pn};
            default: {c_out, sum} = 65'b0;
        endcase
    end
endmodule

module alu64_sparse_carry (
    input [63:0] p,
    input [63:0] g,
    input ci,
    output [63:0] s,
    output co
);
    wire [15:0] gp0, gg0;
    wire [15:0] gp1, gg1;
    wire [15:0] gp2, gg2;
    wire [15:0] gp3, gg3;
    wire [15:0] gp4, gg4;
    wire [16:0] bc;
    wire [63:0] c;
    genvar k;

    assign bc[0] = ci;

    generate
        for (k = 0; k < 16; k = k + 1) begin : groups
            assign gp0[k] = p[4*k+3] & p[4*k+2] & p[4*k+1] & p[4*k];
            assign gg0[k] = g[4*k+3]
                         | (p[4*k+3] & g[4*k+2])
                         | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                         | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);

            assign bc[k+1] = gg4[k] | (gp4[k] & ci);
            assign c[4*k] = bc[k];
            assign c[4*k+1] = g[4*k] | (p[4*k] & bc[k]);
            assign c[4*k+2] = g[4*k+1]
                            | (p[4*k+1] & g[4*k])
                            | (p[4*k+1] & p[4*k] & bc[k]);
            assign c[4*k+3] = g[4*k+2]
                            | (p[4*k+2] & g[4*k+1])
                            | (p[4*k+2] & p[4*k+1] & g[4*k])
                            | (p[4*k+2] & p[4*k+1] & p[4*k] & bc[k]);
        end

        for (k = 0; k < 16; k = k + 1) begin : prefix1
            if (k >= 1) begin : combine
                assign gp1[k] = gp0[k] & gp0[k-1];
                assign gg1[k] = gg0[k] | (gp0[k] & gg0[k-1]);
            end else begin : pass
                assign gp1[k] = gp0[k];
                assign gg1[k] = gg0[k];
            end
        end

        for (k = 0; k < 16; k = k + 1) begin : prefix2
            if (k >= 2) begin : combine
                assign gp2[k] = gp1[k] & gp1[k-2];
                assign gg2[k] = gg1[k] | (gp1[k] & gg1[k-2]);
            end else begin : pass
                assign gp2[k] = gp1[k];
                assign gg2[k] = gg1[k];
            end
        end

        for (k = 0; k < 16; k = k + 1) begin : prefix3
            if (k >= 4) begin : combine
                assign gp3[k] = gp2[k] & gp2[k-4];
                assign gg3[k] = gg2[k] | (gp2[k] & gg2[k-4]);
            end else begin : pass
                assign gp3[k] = gp2[k];
                assign gg3[k] = gg2[k];
            end
        end

        for (k = 0; k < 16; k = k + 1) begin : prefix4
            if (k >= 8) begin : combine
                assign gp4[k] = gp3[k] & gp3[k-8];
                assign gg4[k] = gg3[k] | (gp3[k] & gg3[k-8]);
            end else begin : pass
                assign gp4[k] = gp3[k];
                assign gg4[k] = gg3[k];
            end
        end
    endgenerate

    assign s = p ^ c;
    assign co = bc[16];
endmodule
