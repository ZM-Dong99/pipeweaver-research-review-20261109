module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    wire [7:0] ab_p, ab_g;
    wire [15:0] count1, count2;

    assign ab_p = address ^ b;
    assign ab_g = address & b;

    addr_calcu_branch #(.BASE(base)) branch1 (
        .ab_p(ab_p), .ab_g(ab_g), .ptr(ptr1), .result(count1)
    );
    addr_calcu_branch #(.BASE(base)) branch2 (
        .ab_p(ab_p), .ab_g(ab_g), .ptr(ptr2), .result(count2)
    );

    assign count = (control == 1'b1) ? count1 : count2;
endmodule

module addr_calcu_branch(ab_p, ab_g, ptr, result);
    parameter [7:0] BASE = 8'b10000000;
    input [7:0] ab_p, ab_g;
    input [7:0] ptr;
    output [15:0] result;

    wire [7:0] residue;
    wire subtract_page;
    wire [7:0] s, m;
    wire [7:0] p, g;
    wire [8:0] c;
    wire [7:0] low_sum;
    wire bit8, negative;

    // The assignment deliberately retains only the low eight bits.
    // With BASE=128 this becomes an inversion of ptr[7].
    assign residue = ptr - BASE;
    assign subtract_page = |residue;

    // Carry-save representation of address + b + residue.
    assign s = ab_p ^ residue;
    assign m = ab_g | (ab_p & residue);

    // Add s and (m << 1), with explicit grouped carry lookahead.
    assign p = s ^ {m[6:0], 1'b0};
    assign g = s & {m[6:0], 1'b0};
    assign c[0] = 1'b0;
    assign c[1] = 1'b0;
    assign c[2] = g[1];
    assign c[3] = g[2] | (p[2] & g[1]);
    assign c[4] = g[3] | (p[3] & g[2])
                         | (p[3] & p[2] & g[1]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & g[4])
                         | (p[5] & p[4] & c[4]);
    assign c[7] = g[6] | (p[6] & g[5])
                         | (p[6] & p[5] & g[4])
                         | (p[6] & p[5] & p[4] & c[4]);
    assign c[8] = g[7] | (p[7] & g[6])
                         | (p[7] & p[6] & g[5])
                         | (p[7] & p[6] & p[5] & g[4])
                         | (p[7] & p[6] & p[5] & p[4] & c[4]);

    assign low_sum = p ^ c[7:0];
    assign bit8 = m[7] ^ c[8] ^ subtract_page;
    assign negative = subtract_page & ~m[7] & ~c[8];
    assign result = {{7{negative}}, bit8, low_sum};
endmodule
