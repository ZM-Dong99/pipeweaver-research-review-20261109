module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] px = a ^ b;
    wire [63:0] pe = ~px;
    wire [63:0] ga = a & b;
    wire [63:0] gab = a & ~b;
    wire [63:0] gba = b & ~a;
    wire [63:0] ca, cab, cba;
    wire [63:0] add_result = px ^ ca;
    wire [63:0] ab_result = pe ^ cab;
    wire [63:0] ba_result = pe ^ cba;

    alu64_carry_tree u_add(.p(px), .g(ga), .cin(1'b0), .c(ca));
    alu64_carry_tree u_ab (.p(pe), .g(gab), .cin(1'b1), .c(cab));
    alu64_carry_tree u_ba (.p(pe), .g(gba), .cin(1'b1), .c(cba));

    always @* begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = ab_result;
            3'b010: sum = ba_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = px;
            3'b110: sum = pe;
            default: sum = 64'b0;
        endcase
    end
endmodule

module alu64_carry_tree(
    input [63:0] p,
    input [63:0] g,
    input cin,
    output [63:0] c
);
    wire [15:0] gp0, gg0;
    wire [15:0] gp1, gg1;
    wire [15:0] gp2, gg2;
    wire [15:0] gp3, gg3;
    wire [15:0] gp4, gg4;
    wire [15:0] bc;
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin: blocks
            assign gp0[k] = &p[4*k +: 4];
            assign gg0[k] = g[4*k+3]
                         | (p[4*k+3] & g[4*k+2])
                         | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                         | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
            if (k == 0) begin: first
                assign bc[k] = cin;
            end else begin: later
                assign bc[k] = gg4[k-1] | (gp4[k-1] & cin);
            end
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
        for (k = 0; k < 16; k = k + 1) begin: prefix
            if (k >= 1) begin: s1
                assign gp1[k] = gp0[k] & gp0[k-1];
                assign gg1[k] = gg0[k] | (gp0[k] & gg0[k-1]);
            end else begin: b1
                assign gp1[k] = gp0[k];
                assign gg1[k] = gg0[k];
            end
            if (k >= 2) begin: s2
                assign gp2[k] = gp1[k] & gp1[k-2];
                assign gg2[k] = gg1[k] | (gp1[k] & gg1[k-2]);
            end else begin: b2
                assign gp2[k] = gp1[k];
                assign gg2[k] = gg1[k];
            end
            if (k >= 4) begin: s3
                assign gp3[k] = gp2[k] & gp2[k-4];
                assign gg3[k] = gg2[k] | (gp2[k] & gg2[k-4]);
            end else begin: b3
                assign gp3[k] = gp2[k];
                assign gg3[k] = gg2[k];
            end
            if (k >= 8) begin: s4
                assign gp4[k] = gp3[k] & gp3[k-8];
                assign gg4[k] = gg3[k] | (gp3[k] & gg3[k-8]);
            end else begin: b4
                assign gp4[k] = gp3[k];
                assign gg4[k] = gg3[k];
            end
        end
    endgenerate
endmodule
