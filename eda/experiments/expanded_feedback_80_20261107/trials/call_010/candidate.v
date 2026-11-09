module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    wire [7:0] residue1, residue2;
    wire [15:0] count1, count2;

    assign residue1 = ptr1 - base;
    assign residue2 = ptr2 - base;

    addr_calcu_sum lane1(address, b, residue1, count1);
    addr_calcu_sum lane2(address, b, residue2, count2);

    assign count = (control == 1'b1) ? count1 : count2;
endmodule

module addr_calcu_sum(
    input [7:0] a,
    input [7:0] b,
    input [7:0] r,
    output [15:0] result
);
    wire [7:0] ab_xor;
    wire [7:0] s, majority;
    wire [7:1] p, g;
    wire [8:1] carry;
    wire [7:0] low;
    wire upper0, upper1;
    wire nonzero, negative;

    // Carry-save representation of the three unsigned operands.
    assign ab_xor = a ^ b;
    assign s = ab_xor ^ r;
    assign majority = (a & b) | (ab_xor & r);

    // Add s and (majority << 1), retaining both upper bits.
    assign p = s[7:1] ^ majority[6:0];
    assign g = s[7:1] & majority[6:0];
    assign carry[1] = 1'b0;
    assign carry[2] = g[1];
    assign carry[3] = g[2] | (p[2] & g[1]);
    assign carry[4] = g[3] | (p[3] & g[2])
                    | (p[3] & p[2] & g[1]);
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & g[4])
                    | (p[5] & p[4] & carry[4]);
    assign carry[7] = g[6] | (p[6] & g[5])
                    | (p[6] & p[5] & g[4])
                    | (p[6] & p[5] & p[4] & carry[4]);
    assign carry[8] = g[7] | (p[7] & g[6])
                    | (p[7] & p[6] & g[5])
                    | (p[7] & p[6] & p[5] & g[4])
                    | (p[7] & p[6] & p[5] & p[4] & carry[4]);

    assign low[0] = s[0];
    assign low[7:1] = p ^ carry[7:1];
    assign upper0 = majority[7] ^ carry[8];
    assign upper1 = majority[7] & carry[8];

    // Subtract 256 exactly when the modular residue is nonzero.
    assign nonzero = |r;
    assign negative = nonzero & ~upper1 & ~upper0;
    assign result = {{7{negative}}, (upper0 ^ nonzero), low};
endmodule
