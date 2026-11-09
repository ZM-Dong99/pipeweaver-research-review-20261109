module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    wire [7:0] inverse_offset1, inverse_offset2;
    wire [15:0] count1, count2;

    // Eight-bit arithmetic: ~(base - ptr) = ptr + ~base.
    assign inverse_offset1 = ptr1 + (~base);
    assign inverse_offset2 = ptr2 + (~base);

    addr_calcu_lane lane1 (
        .address(address), .b(b), .inverse_offset(inverse_offset1),
        .result(count1)
    );
    addr_calcu_lane lane2 (
        .address(address), .b(b), .inverse_offset(inverse_offset2),
        .result(count2)
    );

    assign count = (control == 1'b1) ? count1 : count2;
endmodule

module addr_calcu_lane(
    input [7:0] address,
    input [7:0] b,
    input [7:0] inverse_offset,
    output [15:0] result
);
    wire [7:0] s, majority, y;
    wire [7:0] p, g;
    wire [7:0] p1, g1, p2, g2, g3;
    wire [7:0] low_sum;
    wire carry8, negative;

    // Compress address + b + inverse_offset without carry propagation.
    assign s = address ^ b ^ inverse_offset;
    assign majority = (address & b) |
                      ((address | b) & inverse_offset);

    // Add the compressor rows and the subtraction's implicit +1.
    assign y = {majority[6:0], 1'b1};
    assign p = s ^ y;
    assign g = s & y;

    // Parallel-prefix carries for the eight low result bits.
    assign p1 = p & {p[6:0], 1'b0};
    assign g1 = g | (p & {g[6:0], 1'b0});
    assign p2 = p1 & {p1[5:0], 2'b00};
    assign g2 = g1 | (p1 & {g1[5:0], 2'b00});
    assign g3 = g2 | (p2 & {g2[3:0], 4'b0000});

    assign low_sum = p ^ {g3[6:0], 1'b0};
    assign carry8 = g3[7];

    // The full value is address + b + inverse_offset + 1 - 256.
    // Its range is -255 through 510, so only nine low bits and
    // a repeated negative indicator are required.
    assign negative = ~(majority[7] | carry8);
    assign result = {{7{negative}},
                     ~(majority[7] ^ carry8), low_sum};
endmodule
