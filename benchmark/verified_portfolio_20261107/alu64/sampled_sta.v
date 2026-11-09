module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] add_result;
    wire [63:0] sub_ab_result;
    wire [63:0] sub_ba_result;

    alu64_fast_add u_add (
        .x(a), .y(b), .cin(1'b0), .s(add_result)
    );
    alu64_fast_add u_sub_ab (
        .x(a), .y(~b), .cin(1'b1), .s(sub_ab_result)
    );
    alu64_fast_add u_sub_ba (
        .x(b), .y(~a), .cin(1'b1), .s(sub_ba_result)
    );

    always @(*) begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = sub_ab_result;
            3'b010: sum = sub_ba_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = 64'b0;
        endcase
    end
endmodule

module alu64_cla4(
    input [3:0] p,
    input [3:0] g,
    input cin,
    output [4:0] c,
    output pg,
    output gg
);
    assign pg = &p;
    assign gg = g[3]
              | (p[3] & g[2])
              | (p[3] & p[2] & g[1])
              | (p[3] & p[2] & p[1] & g[0]);
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1]
                | (p[1] & g[0])
                | (p[1] & p[0] & cin);
    assign c[3] = g[2]
                | (p[2] & g[1])
                | (p[2] & p[1] & g[0])
                | (p[2] & p[1] & p[0] & cin);
    assign c[4] = gg | (pg & cin);
endmodule

module alu64_fast_add(
    input [63:0] x,
    input [63:0] y,
    input cin,
    output [63:0] s
);
    wire [63:0] p;
    wire [63:0] g;
    wire [15:0] p4;
    wire [15:0] g4;
    wire [15:0] block_cin;
    wire [3:0] p16;
    wire [3:0] g16;
    wire [4:0] super_carry;
    wire unused_pg;
    wire unused_gg;

    assign p = x ^ y;
    assign g = x & y;

    alu64_cla4 top_level (
        .p(p16), .g(g16), .cin(cin),
        .c(super_carry), .pg(unused_pg), .gg(unused_gg)
    );

    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : superblocks
            wire [4:0] local_carry;
            alu64_cla4 middle_level (
                .p(p4[4*j +: 4]),
                .g(g4[4*j +: 4]),
                .cin(super_carry[j]),
                .c(local_carry),
                .pg(p16[j]),
                .gg(g16[j])
            );
            assign block_cin[4*j +: 4] = local_carry[3:0];
        end
    endgenerate

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : blocks
            wire [4:0] local_carry;
            alu64_cla4 bit_level (
                .p(p[4*k +: 4]),
                .g(g[4*k +: 4]),
                .cin(block_cin[k]),
                .c(local_carry),
                .pg(p4[k]),
                .gg(g4[k])
            );
            assign s[4*k +: 4] = p[4*k +: 4] ^ local_carry[3:0];
        end
    endgenerate
endmodule
