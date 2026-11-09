module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] x;
    wire [63:0] eq;
    wire [63:0] add_generate;
    wire [63:0] ab_borrow_generate;
    wire [63:0] ba_borrow_generate;
    wire [63:0] add_carry;
    wire [63:0] ab_borrow;
    wire [63:0] ba_borrow;
    wire [63:0] add_result;
    wire [63:0] ab_result;
    wire [63:0] ba_result;

    assign x = a ^ b;
    assign eq = ~x;
    assign add_generate = a & b;
    assign ab_borrow_generate = (~a) & b;
    assign ba_borrow_generate = a & (~b);

    alu64_carry_tree u_add (
        .p(x), .g(add_generate), .c(add_carry)
    );
    alu64_carry_tree u_ab (
        .p(eq), .g(ab_borrow_generate), .c(ab_borrow)
    );
    alu64_carry_tree u_ba (
        .p(eq), .g(ba_borrow_generate), .c(ba_borrow)
    );

    assign add_result = x ^ add_carry;
    assign ab_result = x ^ ab_borrow;
    assign ba_result = x ^ ba_borrow;

    always @(*) begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = ab_result;
            3'b010: sum = ba_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = x;
            3'b110: sum = eq;
            default: sum = 64'b0;
        endcase
    end
endmodule

module alu64_carry_tree(
    input [63:0] p,
    input [63:0] g,
    output [63:0] c
);
    wire [15:0] gp;
    wire [15:0] gg;
    wire [3:0] sp;
    wire [3:0] sg;
    wire [3:0] sc;
    wire [15:0] gc;

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin: nibble_summary
            assign gp[k] = &p[4*k +: 4];
            assign gg[k] = g[4*k+3]
                         | (p[4*k+3] & g[4*k+2])
                         | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                         | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
        end
        for (k = 0; k < 4; k = k + 1) begin: super_summary
            assign sp[k] = &gp[4*k +: 4];
            assign sg[k] = gg[4*k+3]
                         | (gp[4*k+3] & gg[4*k+2])
                         | (gp[4*k+3] & gp[4*k+2] & gg[4*k+1])
                         | (gp[4*k+3] & gp[4*k+2] & gp[4*k+1] & gg[4*k]);
        end
    endgenerate

    assign sc[0] = 1'b0;
    assign sc[1] = sg[0];
    assign sc[2] = sg[1] | (sp[1] & sg[0]);
    assign sc[3] = sg[2] | (sp[2] & sg[1])
                          | (sp[2] & sp[1] & sg[0]);

    generate
        for (k = 0; k < 4; k = k + 1) begin: nibble_carries
            assign gc[4*k] = sc[k];
            assign gc[4*k+1] = gg[4*k]
                               | (gp[4*k] & sc[k]);
            assign gc[4*k+2] = gg[4*k+1]
                               | (gp[4*k+1] & gg[4*k])
                               | (gp[4*k+1] & gp[4*k] & sc[k]);
            assign gc[4*k+3] = gg[4*k+2]
                               | (gp[4*k+2] & gg[4*k+1])
                               | (gp[4*k+2] & gp[4*k+1] & gg[4*k])
                               | (gp[4*k+2] & gp[4*k+1] & gp[4*k] & sc[k]);
        end
        for (k = 0; k < 16; k = k + 1) begin: bit_carries
            assign c[4*k] = gc[k];
            assign c[4*k+1] = g[4*k]
                              | (p[4*k] & gc[k]);
            assign c[4*k+2] = g[4*k+1]
                              | (p[4*k+1] & g[4*k])
                              | (p[4*k+1] & p[4*k] & gc[k]);
            assign c[4*k+3] = g[4*k+2]
                              | (p[4*k+2] & g[4*k+1])
                              | (p[4*k+2] & p[4*k+1] & g[4*k])
                              | (p[4*k+2] & p[4*k+1] & p[4*k] & gc[k]);
        end
    endgenerate
endmodule
