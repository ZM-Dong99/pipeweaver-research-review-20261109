module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] x, y, p, g, bit_xor;
    wire [63:0] arith;
    wire [15:0] gp, gg;
    wire [15:0] p1, g1, g2;
    wire [15:0] block_c;
    wire cin;

    // Only 000, 001 and 010 select the arithmetic result.
    assign x = a ^ {64{Oper[1]}};
    assign y = b ^ {64{Oper[0]}};
    assign cin = Oper[0] | Oper[1];
    assign p = x | y;
    assign bit_xor = x ^ y;
    assign g[0] = (x[0] & y[0]) | (p[0] & cin);
    assign g[63:1] = x[63:1] & y[63:1];

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin: groups
            assign gp[k] = &p[4*k +: 4];
            assign gg[k] = g[4*k+3]
                          | (p[4*k+3] & g[4*k+2])
                          | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                          | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);

            if (k == 0) begin: first
                assign p1[k] = gp[k];
                assign g1[k] = gg[k];
            end else if (k == 1) begin: second
                assign p1[k] = gp[k] & gp[k-1];
                assign g1[k] = gg[k] | (gp[k] & gg[k-1]);
            end else if (k == 2) begin: third
                assign p1[k] = gp[k] & gp[k-1] & gp[k-2];
                assign g1[k] = gg[k]
                             | (gp[k] & gg[k-1])
                             | (gp[k] & gp[k-1] & gg[k-2]);
            end else begin: remaining
                assign p1[k] = gp[k] & gp[k-1] & gp[k-2] & gp[k-3];
                assign g1[k] = gg[k]
                             | (gp[k] & gg[k-1])
                             | (gp[k] & gp[k-1] & gg[k-2])
                             | (gp[k] & gp[k-1] & gp[k-2] & gg[k-3]);
            end

            if (k < 4) begin: prefix_a
                assign g2[k] = g1[k];
            end else if (k < 8) begin: prefix_b
                assign g2[k] = g1[k] | (p1[k] & g1[k-4]);
            end else if (k < 12) begin: prefix_c
                assign g2[k] = g1[k]
                             | (p1[k] & g1[k-4])
                             | (p1[k] & p1[k-4] & g1[k-8]);
            end else begin: prefix_d
                assign g2[k] = g1[k]
                             | (p1[k] & g1[k-4])
                             | (p1[k] & p1[k-4] & g1[k-8])
                             | (p1[k] & p1[k-4] & p1[k-8] & g1[k-12]);
            end

            if (k == 0) begin: initial_carry
                assign block_c[k] = 1'b0;
                assign arith[4*k] = bit_xor[4*k] ^ cin;
            end else begin: other_carry
                assign block_c[k] = g2[k-1];
                assign arith[4*k] = bit_xor[4*k] ^ block_c[k];
            end
            assign arith[4*k+1] = bit_xor[4*k+1]
                ^ (g[4*k] | (p[4*k] & block_c[k]));
            assign arith[4*k+2] = bit_xor[4*k+2]
                ^ (g[4*k+1]
                   | (p[4*k+1] & g[4*k])
                   | (p[4*k+1] & p[4*k] & block_c[k]));
            assign arith[4*k+3] = bit_xor[4*k+3]
                ^ (g[4*k+2]
                   | (p[4*k+2] & g[4*k+1])
                   | (p[4*k+2] & p[4*k+1] & g[4*k])
                   | (p[4*k+2] & p[4*k+1] & p[4*k] & block_c[k]));
        end
    endgenerate

    always @(*) begin
        case (Oper)
            3'b000, 3'b001, 3'b010: sum = arith;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = 64'b0;
        endcase
    end
endmodule
