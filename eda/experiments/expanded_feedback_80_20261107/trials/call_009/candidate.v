module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    wire [7:0] ptr;
    wire [7:0] neg_offset;
    wire subtract_page;
    wire [7:0] cs_sum, cs_carry;
    wire [7:0] shifted_carry;
    wire [7:0] p0, g0;
    wire [7:0] p1, g1;
    wire [7:0] p2, g2;
    wire [7:0] p3, g3;
    wire [8:0] carry;
    wire [7:0] low_result;
    wire result_bit8, result_negative;

    assign ptr = (control == 1'b1) ? ptr1 : ptr2;

    // Both subtractions are interpreted modulo 256 here.
    // At base=128, neg_offset is simply ptr with bit 7 inverted.
    assign neg_offset = ptr - base;
    assign subtract_page = (ptr != base);

    // Compress three eight-bit operands without carry propagation.
    assign cs_sum = address ^ b ^ neg_offset;
    assign cs_carry = (address & b) |
                      (address & neg_offset) |
                      (b & neg_offset);
    assign shifted_carry = {cs_carry[6:0], 1'b0};

    // Parallel-prefix addition of the two compressed operands.
    assign p0 = cs_sum ^ shifted_carry;
    assign g0 = cs_sum & shifted_carry;

    assign p1 = p0 & {p0[6:0], 1'b1};
    assign g1 = g0 | (p0 & {g0[6:0], 1'b0});

    assign p2 = p1 & {p1[5:0], 2'b11};
    assign g2 = g1 | (p1 & {g1[5:0], 2'b00});

    assign p3 = p2 & {p2[3:0], 4'b1111};
    assign g3 = g2 | (p2 & {g2[3:0], 4'b0000});

    assign carry = {g3, 1'b0};
    assign low_result = p0 ^ carry[7:0];

    // Correct the upper byte for the original eight-bit offset wrap.
    assign result_bit8 = cs_carry[7] ^ carry[8] ^ subtract_page;
    assign result_negative = subtract_page &
                             ~(cs_carry[7] | carry[8]);

    assign count = {{7{result_negative}}, result_bit8, low_result};
endmodule
