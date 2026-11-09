module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    wire [15:0] count1, count2;

    addr_calcu_branch #(.BASE(base)) u_branch1 (
        .address(address), .ptr(ptr1), .b(b), .result(count1)
    );
    addr_calcu_branch #(.BASE(base)) u_branch2 (
        .address(address), .ptr(ptr2), .b(b), .result(count2)
    );

    assign count = (control == 1'b1) ? count1 : count2;
endmodule

module addr_calcu_branch(
    input [7:0] address,
    input [7:0] ptr,
    input [7:0] b,
    output [15:0] result
);
    parameter [7:0] BASE = 8'b10000000;

    wire [7:0] offset;
    wire [7:0] neg_offset;
    wire [7:0] cs_sum, cs_carry;
    wire [7:0] add_rhs;
    wire [7:0] p0, g0;
    wire [7:0] p1, g1;
    wire [7:0] p2, g2;
    wire [7:0] p3, g3;
    wire [7:0] carries;
    wire [7:0] low_result;
    wire bit8, negative;

    assign offset = BASE - ptr;
    assign neg_offset = ~offset;

    // Carry-save reduction of address + b + (255 - offset).
    assign cs_sum = address ^ b ^ neg_offset;
    assign cs_carry = (address & b) |
                      (address & neg_offset) |
                      (b & neg_offset);
    assign add_rhs = {cs_carry[6:0], 1'b0};

    // Eight-bit parallel-prefix addition with carry-in equal to one.
    assign p0 = cs_sum ^ add_rhs;
    assign g0 = cs_sum & add_rhs;

    assign g1 = g0 | (p0 & {g0[6:0], 1'b0});
    assign p1 = p0 & {p0[6:0], 1'b1};
    assign g2 = g1 | (p1 & {g1[5:0], 2'b00});
    assign p2 = p1 & {p1[5:0], 2'b11};
    assign g3 = g2 | (p2 & {g2[3:0], 4'b0000});
    assign p3 = p2 & {p2[3:0], 4'b1111};

    assign carries = g3 | p3;
    assign low_result = p0 ^ {carries[6:0], 1'b1};

    // The carry-save total is address + b - offset + 256.
    // Subtract 256 and sign-extend the exact range [-255, 510].
    assign bit8 = ~(cs_carry[7] ^ carries[7]);
    assign negative = ~(cs_carry[7] | carries[7]);
    assign result = {{7{negative}}, bit8, low_result};
endmodule
