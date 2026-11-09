module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire inv_a;
    wire inv_b;
    wire sub;
    wire [63:0] ax;
    wire [63:0] bx;
    wire [63:0] base_xor;
    wire [63:0] sum_prop;
    wire [63:0] carry_prop;
    wire [63:0] bit_gen;
    wire [63:0] arithmetic_result;
    wire [15:0] group_prop;
    wire [15:0] group_gen;
    wire [15:0] prefix_p [0:4];
    wire [15:0] prefix_g [0:4];
    wire [16:0] block_carry;
    wire en_arithmetic;
    wire en_or;
    wire en_and;
    wire en_xor;
    wire en_xnor;

    assign inv_a = Oper[1];
    assign inv_b = Oper[0];
    assign sub = Oper[1] | Oper[0];
    assign ax = a ^ {64{inv_a}};
    assign bx = b ^ {64{inv_b}};
    assign base_xor = a ^ b;
    assign sum_prop = base_xor ^ {64{sub}};
    assign carry_prop = ax | bx;
    assign bit_gen = ax & bx;
    assign block_carry[0] = sub;

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : blocks
            wire c1;
            wire c2;
            wire c3;

            assign group_prop[k] = &carry_prop[4*k +: 4];
            assign group_gen[k] = bit_gen[4*k+3]
                | (carry_prop[4*k+3] & bit_gen[4*k+2])
                | (carry_prop[4*k+3] & carry_prop[4*k+2]
                   & bit_gen[4*k+1])
                | (carry_prop[4*k+3] & carry_prop[4*k+2]
                   & carry_prop[4*k+1] & bit_gen[4*k]);

            assign prefix_p[0][k] = group_prop[k];
            if (k == 0) begin : first_group
                assign prefix_g[0][k] = group_gen[k]
                    | (group_prop[k] & sub);
            end else begin : later_group
                assign prefix_g[0][k] = group_gen[k];
            end
            assign block_carry[k+1] = prefix_g[4][k];

            assign c1 = bit_gen[4*k]
                | (carry_prop[4*k] & block_carry[k]);
            assign c2 = bit_gen[4*k+1]
                | (carry_prop[4*k+1] & bit_gen[4*k])
                | (carry_prop[4*k+1] & carry_prop[4*k]
                   & block_carry[k]);
            assign c3 = bit_gen[4*k+2]
                | (carry_prop[4*k+2] & bit_gen[4*k+1])
                | (carry_prop[4*k+2] & carry_prop[4*k+1]
                   & bit_gen[4*k])
                | (carry_prop[4*k+2] & carry_prop[4*k+1]
                   & carry_prop[4*k] & block_carry[k]);

            if (k == 0) begin : first_sum_bit
                assign arithmetic_result[4*k] = base_xor[4*k];
            end else begin : other_sum_bits
                assign arithmetic_result[4*k] = sum_prop[4*k]
                    ^ block_carry[k];
            end
            assign arithmetic_result[4*k+1] = sum_prop[4*k+1] ^ c1;
            assign arithmetic_result[4*k+2] = sum_prop[4*k+2] ^ c2;
            assign arithmetic_result[4*k+3] = sum_prop[4*k+3] ^ c3;
        end
    endgenerate

    genvar level;
    genvar column;
    generate
        for (level = 0; level < 4; level = level + 1) begin : prefix_levels
            for (column = 0; column < 16; column = column + 1) begin : columns
                if (column >= (1 << level)) begin : combine
                    assign prefix_g[level+1][column] =
                        prefix_g[level][column]
                        | (prefix_p[level][column]
                           & prefix_g[level][column-(1 << level)]);
                    assign prefix_p[level+1][column] =
                        prefix_p[level][column]
                        & prefix_p[level][column-(1 << level)];
                end else begin : pass_through
                    assign prefix_g[level+1][column] = prefix_g[level][column];
                    assign prefix_p[level+1][column] = prefix_p[level][column];
                end
            end
        end
    endgenerate

    assign en_arithmetic = ~Oper[2] & ~(Oper[1] & Oper[0]);
    assign en_or = (Oper == 3'b011);
    assign en_and = (Oper == 3'b100);
    assign en_xor = (Oper == 3'b101);
    assign en_xnor = (Oper == 3'b110);

    always @(*) begin
        sum = ({64{en_arithmetic}} & arithmetic_result)
            | ({64{en_or}} & (a | b))
            | ({64{en_and}} & (a & b))
            | ({64{en_xor}} & base_xor)
            | ({64{en_xnor}} & ~base_xor);
    end
endmodule
