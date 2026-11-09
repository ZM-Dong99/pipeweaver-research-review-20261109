module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    generate
        if (base == 8'd128) begin : optimized
            wire [15:0] count1, count2;
            addr_calcu_base128_path path1(address, b, ptr1, count1);
            addr_calcu_base128_path path2(address, b, ptr2, count2);
            assign count = (control == 1'b1) ? count1 : count2;
        end else begin : general_base
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

module addr_calcu_base128_path(
    input [7:0] a,
    input [7:0] b,
    input [7:0] ptr,
    output [15:0] result
);
    wire [7:0] ab, s, majority;
    wire [7:0] u, v;
    wire [7:0] p0, p1, p2;
    wire [7:0] g0, g1, g2, g3;
    wire [7:0] low_result;
    wire carry8, wrap_offset, subtract_borrow;
    wire upper_bit, negative;

    // Carry-save representation of a + b + ptr.
    assign ab = a ^ b;
    assign s = ab ^ ptr;
    assign majority = (a & b) | (ab & ptr);

    // Subtract 128 by flipping bit 7, with the corresponding
    // correction handled independently above bit 7.
    assign u = {~s[7], s[6:0]};
    assign v = {majority[6:0], 1'b0};
    assign p0 = u ^ v;
    assign g0 = u & v;

    // Parallel-prefix carry computation; the initial carry is zero.
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : prefix
            if (i >= 1) begin : distance1
                assign p1[i] = p0[i] & p0[i-1];
                assign g1[i] = g0[i] | (p0[i] & g0[i-1]);
            end else begin : first1
                assign p1[i] = p0[i];
                assign g1[i] = g0[i];
            end
            if (i >= 2) begin : distance2
                assign p2[i] = p1[i] & p1[i-2];
                assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
            end else begin : first2
                assign p2[i] = p1[i];
                assign g2[i] = g1[i];
            end
            if (i >= 4) begin : distance4
                assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
            end else begin : first4
                assign g3[i] = g2[i];
            end
        end
    endgenerate

    assign low_result = p0 ^ {g3[6:0], 1'b0};
    assign carry8 = g3[7];
    assign wrap_offset = ptr[7] & (|ptr[6:0]);
    assign subtract_borrow = ~s[7];

    // The upper-byte value is:
    // majority[7] + carry8 - subtract_borrow - wrap_offset.
    // For these inputs it is always -1, 0, or 1.
    assign upper_bit = majority[7] ^ carry8 ^
                       subtract_borrow ^ wrap_offset;
    assign negative =
        ((subtract_borrow | wrap_offset) &
         ~(majority[7] | carry8)) |
        ((subtract_borrow & wrap_offset) &
         ~(majority[7] & carry8));

    assign result = {{7{negative}}, upper_bit, low_result};
endmodule
