module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] x, y, p, g, bit_xor;
    wire [15:0] gp, gg;
    wire [15:0] p1, g1, p2, g2, p4, g4, p8, g8;
    wire [15:0] block_carry;
    wire [63:0] carry_in, arithmetic_result;
    wire arithmetic_enable;
    wire select_or, select_and, select_xor, select_xnor;

    // Carries represent addition carries for 000 and subtraction
    // borrows for 001 and 010. All three start with carry/borrow zero.
    assign x = a ^ {64{Oper[0]}};
    assign y = b ^ {64{Oper[1]}};
    assign p = x | y;
    assign g = x & y;
    assign bit_xor = a ^ b;

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : blocks
            assign gp[k] = &p[4*k +: 4];
            assign gg[k] = g[4*k+3]
                         | (p[4*k+3] & g[4*k+2])
                         | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                         | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);

            if (k == 0) begin : first_block
                assign block_carry[k] = 1'b0;
            end else begin : subsequent_block
                assign block_carry[k] = g8[k-1];
            end

            assign carry_in[4*k] = block_carry[k];
            assign carry_in[4*k+1] = g[4*k]
                                      | (p[4*k] & block_carry[k]);
            assign carry_in[4*k+2] = g[4*k+1]
                                      | (p[4*k+1] & g[4*k])
                                      | (p[4*k+1] & p[4*k] & block_carry[k]);
            assign carry_in[4*k+3] = g[4*k+2]
                                      | (p[4*k+2] & g[4*k+1])
                                      | (p[4*k+2] & p[4*k+1] & g[4*k])
                                      | (p[4*k+2] & p[4*k+1] & p[4*k] & block_carry[k]);
        end

        for (k = 0; k < 16; k = k + 1) begin : group_prefix
            if (k >= 1) begin : distance_one
                assign p1[k] = gp[k] & gp[k-1];
                assign g1[k] = gg[k] | (gp[k] & gg[k-1]);
            end else begin : pass_one
                assign p1[k] = gp[k];
                assign g1[k] = gg[k];
            end
            if (k >= 2) begin : distance_two
                assign p2[k] = p1[k] & p1[k-2];
                assign g2[k] = g1[k] | (p1[k] & g1[k-2]);
            end else begin : pass_two
                assign p2[k] = p1[k];
                assign g2[k] = g1[k];
            end
            if (k >= 4) begin : distance_four
                assign p4[k] = p2[k] & p2[k-4];
                assign g4[k] = g2[k] | (p2[k] & g2[k-4]);
            end else begin : pass_four
                assign p4[k] = p2[k];
                assign g4[k] = g2[k];
            end
            if (k >= 8) begin : distance_eight
                assign p8[k] = p4[k] & p4[k-8];
                assign g8[k] = g4[k] | (p4[k] & g4[k-8]);
            end else begin : pass_eight
                assign p8[k] = p4[k];
                assign g8[k] = g4[k];
            end
        end
    endgenerate

    assign arithmetic_result = bit_xor ^ carry_in;
    assign arithmetic_enable = ~Oper[2] & ~(Oper[1] & Oper[0]);
    assign select_or   = (Oper == 3'b011);
    assign select_and  = (Oper == 3'b100);
    assign select_xor  = (Oper == 3'b101);
    assign select_xnor = (Oper == 3'b110);

    always @* begin
        sum = ({64{arithmetic_enable}} & arithmetic_result)
            | ({64{select_or}} & (a | b))
            | ({64{select_and}} & (a & b))
            | ({64{select_xor}} & bit_xor)
            | ({64{select_xnor}} & ~bit_xor);
    end
endmodule
