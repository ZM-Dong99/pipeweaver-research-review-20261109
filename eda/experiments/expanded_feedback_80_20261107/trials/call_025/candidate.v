module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire inv_a, inv_b, cin;
    wire [63:0] x, y, p, g;
    wire [63:0] arithmetic_result;
    wire [15:0] gp, gg, bc;
    wire [3:0] sp, sg, sc;

    assign inv_a = (Oper == 3'b010);
    assign inv_b = (Oper == 3'b001);
    assign cin = inv_a | inv_b;
    assign x = a ^ {64{inv_a}};
    assign y = b ^ {64{inv_b}};
    assign p = x ^ y;
    assign g = x & y;

    genvar n;
    generate
        for (n = 0; n < 16; n = n + 1) begin : bit_groups
            wire c1, c2, c3;
            assign gp[n] = &p[4*n +: 4];
            assign gg[n] = g[4*n+3]
                         | (p[4*n+3] & g[4*n+2])
                         | (p[4*n+3] & p[4*n+2] & g[4*n+1])
                         | (p[4*n+3] & p[4*n+2] & p[4*n+1] & g[4*n]);
            assign c1 = g[4*n] | (p[4*n] & bc[n]);
            assign c2 = g[4*n+1]
                      | (p[4*n+1] & g[4*n])
                      | (p[4*n+1] & p[4*n] & bc[n]);
            assign c3 = g[4*n+2]
                      | (p[4*n+2] & g[4*n+1])
                      | (p[4*n+2] & p[4*n+1] & g[4*n])
                      | (p[4*n+2] & p[4*n+1] & p[4*n] & bc[n]);
            assign arithmetic_result[4*n +: 4] =
                p[4*n +: 4] ^ {c3, c2, c1, bc[n]};
        end
        for (n = 0; n < 4; n = n + 1) begin : group_groups
            assign sp[n] = &gp[4*n +: 4];
            assign sg[n] = gg[4*n+3]
                         | (gp[4*n+3] & gg[4*n+2])
                         | (gp[4*n+3] & gp[4*n+2] & gg[4*n+1])
                         | (gp[4*n+3] & gp[4*n+2] & gp[4*n+1] & gg[4*n]);
            assign bc[4*n] = sc[n];
            assign bc[4*n+1] = gg[4*n] | (gp[4*n] & sc[n]);
            assign bc[4*n+2] = gg[4*n+1]
                            | (gp[4*n+1] & gg[4*n])
                            | (gp[4*n+1] & gp[4*n] & sc[n]);
            assign bc[4*n+3] = gg[4*n+2]
                            | (gp[4*n+2] & gg[4*n+1])
                            | (gp[4*n+2] & gp[4*n+1] & gg[4*n])
                            | (gp[4*n+2] & gp[4*n+1] & gp[4*n] & sc[n]);
        end
    endgenerate

    assign sc[0] = cin;
    assign sc[1] = sg[0] | (sp[0] & cin);
    assign sc[2] = sg[1]
                 | (sp[1] & sg[0])
                 | (sp[1] & sp[0] & cin);
    assign sc[3] = sg[2]
                 | (sp[2] & sg[1])
                 | (sp[2] & sp[1] & sg[0])
                 | (sp[2] & sp[1] & sp[0] & cin);

    always @(*) begin
        case (Oper)
            3'b000: sum = arithmetic_result;
            3'b001: sum = arithmetic_result;
            3'b010: sum = arithmetic_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = 64'b0;
        endcase
    end
endmodule
