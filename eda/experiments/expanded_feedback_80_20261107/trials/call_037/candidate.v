module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire sub_ab;
    wire sub_ba;
    wire sub;
    wire [63:0] ax, bx;
    wire [63:0] p, g, h;
    wire [63:0] carry;
    wire [63:0] arithmetic_result;
    wire [15:0] gp0, gg0;
    wire [15:0] gp1, gg1;
    wire [15:0] gp2, gg2;
    wire [15:0] gp3, gg3;
    wire [15:0] gp4, gg4;

    assign sub_ab = (Oper == 3'b001);
    assign sub_ba = (Oper == 3'b010);
    assign sub = sub_ab | sub_ba;
    assign ax = a ^ {64{sub_ba}};
    assign bx = b ^ {64{sub_ab}};
    assign p = (a ^ b) ^ {64{sub}};
    assign g = ax & bx;

    // Absorb the subtraction carry-in into the lowest generate term.
    assign h[0] = g[0] | (p[0] & sub);
    assign h[63:1] = g[63:1];
    assign carry[0] = sub;

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin: groups
            wire block_carry;
            assign gp0[k] = &p[4*k +: 4];
            assign gg0[k] = h[4*k+3]
                         | (p[4*k+3] & h[4*k+2])
                         | (p[4*k+3] & p[4*k+2] & h[4*k+1])
                         | (p[4*k+3] & p[4*k+2] & p[4*k+1] & h[4*k]);

            if (k == 0) begin: first_group
                assign block_carry = 1'b0;
            end else begin: later_group
                assign block_carry = gg4[k-1];
                assign carry[4*k] = block_carry;
            end

            assign carry[4*k+1] = h[4*k]
                                  | (p[4*k] & block_carry);
            assign carry[4*k+2] = h[4*k+1]
                                  | (p[4*k+1] & h[4*k])
                                  | (p[4*k+1] & p[4*k] & block_carry);
            assign carry[4*k+3] = h[4*k+2]
                                  | (p[4*k+2] & h[4*k+1])
                                  | (p[4*k+2] & p[4*k+1] & h[4*k])
                                  | (p[4*k+2] & p[4*k+1] & p[4*k] & block_carry);
        end

        for (k = 0; k < 16; k = k + 1) begin: prefix
            if (k >= 1) begin: distance_1
                assign gg1[k] = gg0[k] | (gp0[k] & gg0[k-1]);
                assign gp1[k] = gp0[k] & gp0[k-1];
            end else begin: pass_1
                assign gg1[k] = gg0[k];
                assign gp1[k] = gp0[k];
            end
            if (k >= 2) begin: distance_2
                assign gg2[k] = gg1[k] | (gp1[k] & gg1[k-2]);
                assign gp2[k] = gp1[k] & gp1[k-2];
            end else begin: pass_2
                assign gg2[k] = gg1[k];
                assign gp2[k] = gp1[k];
            end
            if (k >= 4) begin: distance_4
                assign gg3[k] = gg2[k] | (gp2[k] & gg2[k-4]);
                assign gp3[k] = gp2[k] & gp2[k-4];
            end else begin: pass_4
                assign gg3[k] = gg2[k];
                assign gp3[k] = gp2[k];
            end
            if (k >= 8) begin: distance_8
                assign gg4[k] = gg3[k] | (gp3[k] & gg3[k-8]);
                assign gp4[k] = gp3[k] & gp3[k-8];
            end else begin: pass_8
                assign gg4[k] = gg3[k];
                assign gp4[k] = gp3[k];
            end
        end
    endgenerate

    assign arithmetic_result = p ^ carry;

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
