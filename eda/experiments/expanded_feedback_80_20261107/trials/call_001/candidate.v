module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] x;
    wire [63:0] ca, cs, cr;
    wire [63:0] add_result, sub_result, reverse_result;

    assign x = a ^ b;

    alu64_carry_tree u_add (
        .p(x), .g(a & b), .cin(1'b0), .c(ca)
    );
    alu64_carry_tree u_sub (
        .p(~x), .g(a & ~b), .cin(1'b1), .c(cs)
    );
    alu64_carry_tree u_reverse (
        .p(~x), .g(~a & b), .cin(1'b1), .c(cr)
    );

    assign add_result = x ^ ca;
    assign sub_result = (~x) ^ cs;
    assign reverse_result = (~x) ^ cr;

    always @(*) begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = sub_result;
            3'b010: sum = reverse_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = x;
            3'b110: sum = ~x;
            default: sum = 64'b0;
        endcase
    end
endmodule

module alu64_carry_tree(
    input [63:0] p,
    input [63:0] g,
    input cin,
    output [63:0] c
);
    wire [15:0] gp, gg;
    wire [3:0] sp, sg;
    wire [3:0] sc;
    wire [15:0] gc;

    genvar n;
    generate
        for (n = 0; n < 16; n = n + 1) begin : nibble_summary
            assign gp[n] = &p[4*n+3:4*n];
            assign gg[n] = g[4*n+3]
                         | (p[4*n+3] & g[4*n+2])
                         | (p[4*n+3] & p[4*n+2] & g[4*n+1])
                         | (p[4*n+3] & p[4*n+2] & p[4*n+1] & g[4*n]);
        end
        for (n = 0; n < 4; n = n + 1) begin : super_summary
            assign sp[n] = &gp[4*n+3:4*n];
            assign sg[n] = gg[4*n+3]
                         | (gp[4*n+3] & gg[4*n+2])
                         | (gp[4*n+3] & gp[4*n+2] & gg[4*n+1])
                         | (gp[4*n+3] & gp[4*n+2] & gp[4*n+1] & gg[4*n]);
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

    generate
        for (n = 0; n < 4; n = n + 1) begin : group_carries
            assign gc[4*n] = sc[n];
            assign gc[4*n+1] = gg[4*n]
                              | (gp[4*n] & sc[n]);
            assign gc[4*n+2] = gg[4*n+1]
                              | (gp[4*n+1] & gg[4*n])
                              | (gp[4*n+1] & gp[4*n] & sc[n]);
            assign gc[4*n+3] = gg[4*n+2]
                              | (gp[4*n+2] & gg[4*n+1])
                              | (gp[4*n+2] & gp[4*n+1] & gg[4*n])
                              | (gp[4*n+2] & gp[4*n+1] & gp[4*n] & sc[n]);
        end
        for (n = 0; n < 16; n = n + 1) begin : bit_carries
            assign c[4*n] = gc[n];
            assign c[4*n+1] = g[4*n]
                             | (p[4*n] & gc[n]);
            assign c[4*n+2] = g[4*n+1]
                             | (p[4*n+1] & g[4*n])
                             | (p[4*n+1] & p[4*n] & gc[n]);
            assign c[4*n+3] = g[4*n+2]
                             | (p[4*n+2] & g[4*n+1])
                             | (p[4*n+2] & p[4*n+1] & g[4*n])
                             | (p[4*n+2] & p[4*n+1] & p[4*n] & gc[n]);
        end
    endgenerate
endmodule
