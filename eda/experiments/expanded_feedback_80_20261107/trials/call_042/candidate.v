module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    generate
        if (base == 8'h80) begin : optimized_base128
            wire [7:0] ptr;
            wire [7:0] q;
            wire [7:0] cs_sum, cs_carry;
            wire [8:0] x, y;
            wire [8:0] p0, g0;
            wire [8:0] p1, g1;
            wire [8:0] p2, g2;
            wire [8:0] p3, g3;
            wire [8:0] g4;
            wire [9:0] total;
            wire subtract_256;
            wire negative_result;

            assign ptr = (control == 1'b1) ? ptr1 : ptr2;
            assign q = {~ptr[7], ptr[6:0]};

            // Compress three unsigned eight-bit operands without
            // propagating carry through either operand addition.
            assign cs_sum = address ^ b ^ q;
            assign cs_carry = (address & b) | (address & q) | (b & q);
            assign x = {1'b0, cs_sum};
            assign y = {cs_carry, 1'b0};
            assign p0 = x ^ y;
            assign g0 = x & y;

            // Parallel-prefix carry generation, with zero carry-in.
            assign g1 = g0 | (p0 & (g0 << 1));
            assign p1 = p0 & ((p0 << 1) | 9'b000000001);
            assign g2 = g1 | (p1 & (g1 << 2));
            assign p2 = p1 & ((p1 << 2) | 9'b000000011);
            assign g3 = g2 | (p2 & (g2 << 4));
            assign p3 = p2 & ((p2 << 4) | 9'b000001111);
            assign g4 = g3 | (p3 & (g3 << 8));

            assign total[8:0] = p0 ^ {g4[7:0], 1'b0};
            assign total[9] = g4[8];

            // -((128-ptr) mod 256) equals q-256 when q!=0,
            // and equals zero when q==0.
            assign subtract_256 = |q;
            assign negative_result = subtract_256 & ~total[9] & ~total[8];
            assign count = {{7{negative_result}},
                            (total[8] ^ subtract_256), total[7:0]};
        end else begin : other_bases
            wire [7:0] offset1, offset2;
            wire [15:0] addr1, addr2;
            wire [15:0] count1, count2;

            assign offset1 = base - ptr1;
            assign offset2 = base - ptr2;
            assign addr1 = address - {8'h00, offset1};
            assign addr2 = address - {8'h00, offset2};
            assign count1 = addr1 + b;
            assign count2 = addr2 + b;
            assign count = (control == 1'b1) ? count1 : count2;
        end
    endgenerate
endmodule
