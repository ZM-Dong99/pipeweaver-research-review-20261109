module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    wire [7:0] ab_xor, ab_and;
    wire [15:0] count1, count2;

    assign ab_xor = address ^ b;
    assign ab_and = address & b;

    addr_calcu_branch #(.BASE(base)) u_branch1 (
        .ab_xor(ab_xor), .ab_and(ab_and), .ptr(ptr1),
        .result(count1)
    );
    addr_calcu_branch #(.BASE(base)) u_branch2 (
        .ab_xor(ab_xor), .ab_and(ab_and), .ptr(ptr2),
        .result(count2)
    );

    assign count = (control == 1'b1) ? count1 : count2;
endmodule

module addr_calcu_branch(ab_xor, ab_and, ptr, result);
    parameter [7:0] BASE = 8'b10000000;
    input [7:0] ab_xor;
    input [7:0] ab_and;
    input [7:0] ptr;
    output [15:0] result;

    wire [7:0] neg_offset;
    wire nonzero_offset;
    wire [7:0] s, m;
    wire [6:0] p, g;
    wire [6:0] p1, g1, p2, g2, g3;
    wire [7:0] low_sum;
    wire carry8;
    wire upper_bit;

    // Eight-bit modular negation of the original offset.
    // With BASE=128 this reduces to an MSB inversion.
    assign neg_offset = ptr - BASE;
    assign nonzero_offset = |neg_offset;

    // Carry-save representation of address + b + neg_offset.
    assign s = ab_xor ^ neg_offset;
    assign m = ab_and | (ab_xor & neg_offset);

    // Add s[7:1] and m[6:0], with no incoming carry.
    assign p = s[7:1] ^ m[6:0];
    assign g = s[7:1] & m[6:0];

    assign p1 = p & {p[5:0], 1'b1};
    assign g1 = g | (p & {g[5:0], 1'b0});
    assign p2 = p1 & {p1[4:0], 2'b11};
    assign g2 = g1 | (p1 & {g1[4:0], 2'b00});
    assign g3 = g2 | (p2 & {g2[2:0], 4'b0000});

    assign low_sum[0] = s[0];
    assign low_sum[7:1] = p ^ {g3[5:0], 1'b0};
    assign carry8 = g3[6];

    // The uncorrected sum is at most 765. Subtract 256
    // exactly when the original eight-bit offset is nonzero.
    assign upper_bit = nonzero_offset & ~(m[7] | carry8);
    assign result = {{7{upper_bit}},
                     (m[7] ^ carry8 ^ nonzero_offset), low_sum};
endmodule
