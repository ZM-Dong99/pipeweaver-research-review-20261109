module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] x, y, p, g;
    wire cin;
    wire [15:0] gp [0:4];
    wire [15:0] gg [0:4];
    wire [16:0] block_c;
    wire [63:0] arithmetic_result;
    wire arithmetic_enable;
    wire or_enable, and_enable, xor_enable, xnor_enable;

    // In arithmetic modes: a+b, a+(~b)+1, or (~a)+b+1.
    assign x = a ^ {64{Oper[1]}};
    assign y = b ^ {64{Oper[0]}};
    assign cin = Oper[1] | Oper[0];
    assign p = x ^ y;
    assign g = x & y;

    genvar k, s, j;
    generate
        for (k = 0; k < 16; k = k + 1) begin : blocks
            assign gp[0][k] = &p[4*k +: 4];
            assign gg[0][k] = g[4*k+3]
                           | (p[4*k+3] & g[4*k+2])
                           | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                           | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
        end
        for (s = 0; s < 4; s = s + 1) begin : prefix_levels
            for (j = 0; j < 16; j = j + 1) begin : prefix_nodes
                if (j >= (1 << s)) begin : combine
                    assign gg[s+1][j] = gg[s][j]
                        | (gp[s][j] & gg[s][j-(1 << s)]);
                    assign gp[s+1][j] = gp[s][j] & gp[s][j-(1 << s)];
                end else begin : pass_through
                    assign gg[s+1][j] = gg[s][j];
                    assign gp[s+1][j] = gp[s][j];
                end
            end
        end
    endgenerate

    assign block_c[0] = cin;
    generate
        for (k = 0; k < 16; k = k + 1) begin : result_blocks
            wire c1, c2, c3;
            assign block_c[k+1] = gg[4][k] | (gp[4][k] & cin);
            assign c1 = g[4*k] | (p[4*k] & block_c[k]);
            assign c2 = g[4*k+1]
                      | (p[4*k+1] & g[4*k])
                      | (p[4*k+1] & p[4*k] & block_c[k]);
            assign c3 = g[4*k+2]
                      | (p[4*k+2] & g[4*k+1])
                      | (p[4*k+2] & p[4*k+1] & g[4*k])
                      | (p[4*k+2] & p[4*k+1] & p[4*k] & block_c[k]);
            assign arithmetic_result[4*k +: 4] = p[4*k +: 4]
                                                  ^ {c3, c2, c1, block_c[k]};
        end
    endgenerate

    assign arithmetic_enable = ~Oper[2] & ~(Oper[1] & Oper[0]);
    assign or_enable   = (Oper == 3'b011);
    assign and_enable  = (Oper == 3'b100);
    assign xor_enable  = (Oper == 3'b101);
    assign xnor_enable = (Oper == 3'b110);

    always @(*) begin
        sum = ({64{arithmetic_enable}} & arithmetic_result)
            | ({64{or_enable}} & (a | b))
            | ({64{and_enable}} & (a & b))
            | ({64{xor_enable}} & (a ^ b))
            | ({64{xnor_enable}} & (a ~^ b));
    end
endmodule
