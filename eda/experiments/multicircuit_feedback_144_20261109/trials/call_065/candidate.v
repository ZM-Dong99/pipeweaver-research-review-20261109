module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] axb;
    wire [63:0] carry_add, borrow_ab, borrow_ba;
    wire [63:0] add_result, sub_ab_result, sub_ba_result;

    assign axb = a ^ b;
    alu64_carry_tree u_add (
        .p(a | b), .g(a & b), .c(carry_add)
    );
    alu64_carry_tree u_sub_ab (
        .p((~a) | b), .g((~a) & b), .c(borrow_ab)
    );
    alu64_carry_tree u_sub_ba (
        .p(a | (~b)), .g(a & (~b)), .c(borrow_ba)
    );
    assign add_result = axb ^ carry_add;
    assign sub_ab_result = axb ^ borrow_ab;
    assign sub_ba_result = axb ^ borrow_ba;

    always @* begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = sub_ab_result;
            3'b010: sum = sub_ba_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = axb;
            3'b110: sum = ~axb;
            default: sum = 64'b0;
        endcase
    end
endmodule

module alu64_carry_tree (
    input [63:0] p,
    input [63:0] g,
    output [63:0] c
);
    wire [15:0] pp [0:2];
    wire [15:0] gg [0:2];
    wire [15:0] block_carry;
    genvar k, s, j, i;
    generate
        for (k = 0; k < 16; k = k + 1) begin: blocks
            assign pp[0][k] = &p[4*k +: 4];
            assign gg[0][k] = g[4*k+3]
                | (p[4*k+3] & g[4*k+2])
                | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
        end
        for (s = 0; s < 2; s = s + 1) begin: prefix_stage
            localparam integer D = (1 << (2*s));
            for (j = 0; j < 16; j = j + 1) begin: prefix_node
                if (j >= 3*D) begin: four
                    assign pp[s+1][j] = pp[s][j] & pp[s][j-D]
                        & pp[s][j-2*D] & pp[s][j-3*D];
                    assign gg[s+1][j] = gg[s][j]
                        | (pp[s][j] & gg[s][j-D])
                        | (pp[s][j] & pp[s][j-D] & gg[s][j-2*D])
                        | (pp[s][j] & pp[s][j-D] & pp[s][j-2*D] & gg[s][j-3*D]);
                end else if (j >= 2*D) begin: three
                    assign pp[s+1][j] = pp[s][j] & pp[s][j-D] & pp[s][j-2*D];
                    assign gg[s+1][j] = gg[s][j]
                        | (pp[s][j] & gg[s][j-D])
                        | (pp[s][j] & pp[s][j-D] & gg[s][j-2*D]);
                end else if (j >= D) begin: two
                    assign pp[s+1][j] = pp[s][j] & pp[s][j-D];
                    assign gg[s+1][j] = gg[s][j] | (pp[s][j] & gg[s][j-D]);
                end else begin: one
                    assign pp[s+1][j] = pp[s][j];
                    assign gg[s+1][j] = gg[s][j];
                end
            end
        end
        for (k = 0; k < 16; k = k + 1) begin: boundary
            if (k == 0) begin: first
                assign block_carry[k] = 1'b0;
            end else begin: later
                assign block_carry[k] = gg[2][k-1];
            end
            assign c[4*k] = block_carry[k];
            assign c[4*k+1] = g[4*k] | (p[4*k] & block_carry[k]);
            assign c[4*k+2] = g[4*k+1]
                | (p[4*k+1] & g[4*k])
                | (p[4*k+1] & p[4*k] & block_carry[k]);
            assign c[4*k+3] = g[4*k+2]
                | (p[4*k+2] & g[4*k+1])
                | (p[4*k+2] & p[4*k+1] & g[4*k])
                | (p[4*k+2] & p[4*k+1] & p[4*k] & block_carry[k]);
        end
    endgenerate
endmodule
