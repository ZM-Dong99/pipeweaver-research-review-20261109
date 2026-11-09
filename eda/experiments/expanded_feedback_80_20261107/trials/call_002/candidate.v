module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire sub_ab, sub_ba, sub_any;
    wire en_arith, en_or, en_and, en_xor, en_xnor;
    wire [63:0] x, y, axb, p, g;
    wire [63:0] arithmetic_result;
    wire [15:0] pg [0:4];
    wire [15:0] gg [0:4];
    wire [16:0] block_carry;

    assign sub_ab = (Oper == 3'b001);
    assign sub_ba = (Oper == 3'b010);
    assign sub_any = sub_ab | sub_ba;
    assign en_arith = ~Oper[2] & ~(Oper[1] & Oper[0]);
    assign en_or   = (Oper == 3'b011);
    assign en_and  = (Oper == 3'b100);
    assign en_xor  = (Oper == 3'b101);
    assign en_xnor = (Oper == 3'b110);

    assign x = a ^ {64{sub_ba}};
    assign y = b ^ {64{sub_ab}};
    assign axb = a ^ b;
    assign p = axb ^ {64{sub_any}};
    assign g = x & y;
    assign block_carry[0] = sub_any;

    genvar k, s, j;
    generate
        for (k = 0; k < 16; k = k + 1) begin: groups
            assign pg[0][k] = &p[4*k +: 4];
            assign gg[0][k] = g[4*k+3]
                           | (p[4*k+3] & g[4*k+2])
                           | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                           | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);

            assign block_carry[k+1] = gg[4][k]
                                    | (pg[4][k] & sub_any);

            assign arithmetic_result[4*k] = p[4*k] ^ block_carry[k];
            assign arithmetic_result[4*k+1] = p[4*k+1]
                ^ (g[4*k] | (p[4*k] & block_carry[k]));
            assign arithmetic_result[4*k+2] = p[4*k+2]
                ^ (g[4*k+1]
                   | (p[4*k+1] & g[4*k])
                   | (p[4*k+1] & p[4*k] & block_carry[k]));
            assign arithmetic_result[4*k+3] = p[4*k+3]
                ^ (g[4*k+2]
                   | (p[4*k+2] & g[4*k+1])
                   | (p[4*k+2] & p[4*k+1] & g[4*k])
                   | (p[4*k+2] & p[4*k+1] & p[4*k]
                      & block_carry[k]));
        end

        for (s = 0; s < 4; s = s + 1) begin: prefix_stage
            for (j = 0; j < 16; j = j + 1) begin: prefix_bit
                if (j >= (1 << s)) begin: combine
                    assign gg[s+1][j] = gg[s][j]
                        | (pg[s][j] & gg[s][j-(1 << s)]);
                    assign pg[s+1][j] = pg[s][j]
                        & pg[s][j-(1 << s)];
                end else begin: pass_through
                    assign gg[s+1][j] = gg[s][j];
                    assign pg[s+1][j] = pg[s][j];
                end
            end
        end
    endgenerate

    always @(*) begin
        sum = (arithmetic_result & {64{en_arith}})
            | ((a | b) & {64{en_or}})
            | ((a & b) & {64{en_and}})
            | (axb & {64{en_xor}})
            | ((~axb) & {64{en_xnor}});
    end
endmodule
