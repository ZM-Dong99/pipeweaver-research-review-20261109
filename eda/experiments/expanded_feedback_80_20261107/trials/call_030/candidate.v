module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    wire [7:0] q1, q2;
    wire [7:0] common_x, common_g;
    wire [15:0] count1, count2;

    assign q1 = ptr1 - base;
    assign q2 = ptr2 - base;
    assign common_x = address ^ b;
    assign common_g = address & b;

    addr_calcu_branch u1 (
        .common_x(common_x), .common_g(common_g),
        .q(q1), .result(count1)
    );
    addr_calcu_branch u2 (
        .common_x(common_x), .common_g(common_g),
        .q(q2), .result(count2)
    );

    assign count = (control == 1'b1) ? count1 : count2;
endmodule

module addr_calcu_branch(
    input [7:0] common_x,
    input [7:0] common_g,
    input [7:0] q,
    output [15:0] result
);
    wire [7:0] x, m;
    wire [7:1] p, g, sx;
    wire [8:1] c;
    wire [7:0] low;
    wire nz, negative, high_bit;

    // Carry-save representation of address + b + q.
    assign x = common_x ^ q;
    assign m = common_g | (common_x & q);

    // Add x to the one-bit-left-shifted majority vector.
    // Bit zero has no second operand, hence c[1] is zero.
    assign sx = x[7:1] ^ m[6:0];
    assign p = x[7:1] | m[6:0];
    assign g = x[7:1] & m[6:0];
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

    assign low[0] = x[0];
    assign low[7:1] = sx ^ c[7:1];

    // Subtract 256 exactly when the wrapped negated offset is nonzero.
    assign nz = |q;
    assign negative = nz & ~m[7] & ~c[8];
    assign high_bit = m[7] ^ c[8] ^ nz;
    assign result = {{7{negative}}, high_bit, low};
endmodule
