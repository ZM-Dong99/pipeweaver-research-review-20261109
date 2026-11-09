module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    wire [7:0] offset1, offset2;
    wire [15:0] count1, count2;

    assign offset1 = base - ptr1;
    assign offset2 = base - ptr2;

    addr_calcu_branch branch1 (
        .address(address), .b(b), .offset(offset1), .result(count1)
    );
    addr_calcu_branch branch2 (
        .address(address), .b(b), .offset(offset2), .result(count2)
    );

    assign count = (control == 1'b1) ? count1 : count2;
endmodule

module addr_calcu_branch(
    input [7:0] address,
    input [7:0] b,
    input [7:0] offset,
    output [15:0] result
);
    wire [7:0] inverted_offset;
    wire [7:0] partial_sum, majority;
    wire [7:0] shifted_majority;
    wire [7:0] p, g;
    wire [7:0] p1, g1, p2, g2, g3;
    wire [7:0] carry, low_sum;
    wire negative, bit8;

    assign inverted_offset = ~offset;

    // Carry-save compression of address + b + (255 - offset).
    assign partial_sum = address ^ b ^ inverted_offset;
    assign majority = (address & b) |
                      (address & inverted_offset) |
                      (b & inverted_offset);

    // Include the subtraction's +1 in the shifted carry operand.
    assign shifted_majority = {majority[6:0], 1'b1};
    assign p = partial_sum ^ shifted_majority;
    assign g = partial_sum & shifted_majority;

    // Eight-bit parallel-prefix carry computation, with carry-in zero.
    assign g1 = g | (p & (g << 1));
    assign p1 = p & (p << 1);
    assign g2 = g1 | (p1 & (g1 << 2));
    assign p2 = p1 & (p1 << 2);
    assign g3 = g2 | (p2 & (g2 << 4));

    assign carry = {g3[6:0], 1'b0};
    assign low_sum = p ^ carry;

    // The compressed unsigned total is address + b - offset + 256.
    // Its upper column adds majority[7] and the low-byte carry-out.
    assign negative = ~(majority[7] | g3[7]);
    assign bit8 = ~(majority[7] ^ g3[7]);
    assign result = {{7{negative}}, bit8, low_sum};
endmodule
