module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] px = a ^ b;
    wire [63:0] ps = ~px;
    wire [63:0] add_result, ab_result, ba_result;
    wire [63:0] ga = a & b;
    wire [63:0] gab = a & ~b;
    wire [63:0] gba = b & ~a;

    alu64_sparse_carry u_add(.p(px), .g(ga), .cin(1'b0), .s(add_result));
    alu64_sparse_carry u_ab (.p(ps), .g(gab), .cin(1'b1), .s(ab_result));
    alu64_sparse_carry u_ba (.p(ps), .g(gba), .cin(1'b1), .s(ba_result));

    always @* begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = ab_result;
            3'b010: sum = ba_result;
            3'b011: sum = a | b;
            3'b100: sum = ga;
            3'b101: sum = px;
            3'b110: sum = ps;
            default: sum = 64'b0;
        endcase
    end
endmodule

module alu64_sparse_carry(
    input [63:0] p,
    input [63:0] g,
    input cin,
    output [63:0] s
);
    wire [63:0] ge;
    wire [15:0] gp;
    wire [15:0] gg;
    wire [15:0] pp1, pp2, pp3, pp4;
    wire [15:0] gg1, gg2, gg3, gg4;
    wire [16:0] boundary;
    assign ge = {g[63:1], (g[0] | (p[0] & cin))};
    assign boundary[0] = 1'b0;
    assign boundary[16:1] = gg4;

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin: blocks
            wire c0, c1, c2, c3;
            assign gp[k] = &p[4*k +: 4];
            assign gg[k] = ge[4*k+3]
                         | (p[4*k+3] & ge[4*k+2])
                         | (p[4*k+3] & p[4*k+2] & ge[4*k+1])
                         | (p[4*k+3] & p[4*k+2] & p[4*k+1] & ge[4*k]);
            assign c0 = boundary[k];
            assign c1 = ge[4*k] | (p[4*k] & c0);
            assign c2 = ge[4*k+1]
                      | (p[4*k+1] & ge[4*k])
                      | (p[4*k+1] & p[4*k] & c0);
            assign c3 = ge[4*k+2]
                      | (p[4*k+2] & ge[4*k+1])
                      | (p[4*k+2] & p[4*k+1] & ge[4*k])
                      | (p[4*k+2] & p[4*k+1] & p[4*k] & c0);
            if (k == 0) begin: first
                assign s[4*k] = p[4*k] ^ cin;
            end else begin: later
                assign s[4*k] = p[4*k] ^ c0;
            end
            assign s[4*k+1] = p[4*k+1] ^ c1;
            assign s[4*k+2] = p[4*k+2] ^ c2;
            assign s[4*k+3] = p[4*k+3] ^ c3;

            if (k >= 1) begin: level1
                assign gg1[k] = gg[k] | (gp[k] & gg[k-1]);
                assign pp1[k] = gp[k] & gp[k-1];
            end else begin: pass1
                assign gg1[k] = gg[k];
                assign pp1[k] = gp[k];
            end
            if (k >= 2) begin: level2
                assign gg2[k] = gg1[k] | (pp1[k] & gg1[k-2]);
                assign pp2[k] = pp1[k] & pp1[k-2];
            end else begin: pass2
                assign gg2[k] = gg1[k];
                assign pp2[k] = pp1[k];
            end
            if (k >= 4) begin: level3
                assign gg3[k] = gg2[k] | (pp2[k] & gg2[k-4]);
                assign pp3[k] = pp2[k] & pp2[k-4];
            end else begin: pass3
                assign gg3[k] = gg2[k];
                assign pp3[k] = pp2[k];
            end
            if (k >= 8) begin: level4
                assign gg4[k] = gg3[k] | (pp3[k] & gg3[k-8]);
                assign pp4[k] = pp3[k] & pp3[k-8];
            end else begin: pass4
                assign gg4[k] = gg3[k];
                assign pp4[k] = pp3[k];
            end
        end
    endgenerate
endmodule
