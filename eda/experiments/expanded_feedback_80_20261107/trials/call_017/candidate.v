module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire neg_a;
    wire neg_b;
    wire carry_in;
    wire [63:0] x, y;
    wire [63:0] p, g;
    wire [63:0] arithmetic_result;
    wire [15:0] block_p, block_g;
    wire [15:0] prefix_p [0:4];
    wire [15:0] prefix_g [0:4];
    wire [16:0] block_carry;

    assign neg_a = (Oper == 3'b010);
    assign neg_b = (Oper == 3'b001);
    assign carry_in = neg_a | neg_b;
    assign x = a ^ {64{neg_a}};
    assign y = b ^ {64{neg_b}};
    assign p = x ^ y;
    assign g = x & y;

    genvar k, s, j;
    generate
        for (k = 0; k < 16; k = k + 1) begin: make_blocks
            assign block_p[k] = &p[4*k +: 4];
            assign block_g[k] = g[4*k+3]
                | (p[4*k+3] & g[4*k+2])
                | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
        end
    endgenerate

    assign prefix_p[0] = block_p;
    // Fold the initial carry into the lowest block's generate signal.
    assign prefix_g[0] = block_g
                      | {15'b0, (block_p[0] & carry_in)};

    generate
        for (s = 0; s < 4; s = s + 1) begin: prefix_stage
            for (j = 0; j < 16; j = j + 1) begin: prefix_node
                if (j >= (1 << s)) begin: combine
                    assign prefix_g[s+1][j] = prefix_g[s][j]
                        | (prefix_p[s][j] & prefix_g[s][j-(1 << s)]);
                    assign prefix_p[s+1][j] = prefix_p[s][j]
                        & prefix_p[s][j-(1 << s)];
                end else begin: pass_through
                    assign prefix_g[s+1][j] = prefix_g[s][j];
                    assign prefix_p[s+1][j] = prefix_p[s][j];
                end
            end
        end
    endgenerate

    assign block_carry[0] = carry_in;
    assign block_carry[16:1] = prefix_g[4];

    generate
        for (k = 0; k < 16; k = k + 1) begin: finish_blocks
            wire c1, c2, c3;
            assign c1 = g[4*k]
                      | (p[4*k] & block_carry[k]);
            assign c2 = g[4*k+1]
                      | (p[4*k+1] & g[4*k])
                      | (p[4*k+1] & p[4*k] & block_carry[k]);
            assign c3 = g[4*k+2]
                      | (p[4*k+2] & g[4*k+1])
                      | (p[4*k+2] & p[4*k+1] & g[4*k])
                      | (p[4*k+2] & p[4*k+1] & p[4*k] & block_carry[k]);
            assign arithmetic_result[4*k]   = p[4*k]   ^ block_carry[k];
            assign arithmetic_result[4*k+1] = p[4*k+1] ^ c1;
            assign arithmetic_result[4*k+2] = p[4*k+2] ^ c2;
            assign arithmetic_result[4*k+3] = p[4*k+3] ^ c3;
        end
    endgenerate

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
