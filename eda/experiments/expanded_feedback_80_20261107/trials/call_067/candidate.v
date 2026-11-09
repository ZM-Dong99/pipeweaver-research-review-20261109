module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    wire [7:0] ab_xor, ab_and;
    wire [7:0] neg_offset1, neg_offset2;
    wire [15:0] count1, count2;

    assign ab_xor = address ^ b;
    assign ab_and = address & b;
    assign neg_offset1 = ptr1 - base;
    assign neg_offset2 = ptr2 - base;

    addr_calcu_sum_branch u_branch1(
        .ab_xor(ab_xor),
        .ab_and(ab_and),
        .neg_offset(neg_offset1),
        .result(count1)
    );
    addr_calcu_sum_branch u_branch2(
        .ab_xor(ab_xor),
        .ab_and(ab_and),
        .neg_offset(neg_offset2),
        .result(count2)
    );

    assign count = (control == 1'b1) ? count1 : count2;
endmodule

module addr_calcu_sum_branch(
    input [7:0] ab_xor,
    input [7:0] ab_and,
    input [7:0] neg_offset,
    output [15:0] result
);
    wire [7:0] csa_sum, csa_carry;
    wire [7:0] shifted_carry;
    wire [7:0] p0, g0;
    wire [7:0] p1, g1;
    wire [7:0] p2, g2;
    wire [7:0] p3, g3;
    wire subtract_256;
    wire negative_result;

    // address + b + neg_offset = csa_sum + (csa_carry << 1).
    assign csa_sum = ab_xor ^ neg_offset;
    assign csa_carry = ab_and | (ab_xor & neg_offset);
    assign shifted_carry = {csa_carry[6:0], 1'b0};
    assign p0 = csa_sum ^ shifted_carry;
    assign g0 = csa_sum & shifted_carry;

    // Eight-bit parallel-prefix addition, with zero carry-in.
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : prefix_distance_1
            if (i >= 1) begin : combine
                assign p1[i] = p0[i] & p0[i-1];
                assign g1[i] = g0[i] | (p0[i] & g0[i-1]);
            end else begin : pass_through
                assign p1[i] = p0[i];
                assign g1[i] = g0[i];
            end
        end
        for (i = 0; i < 8; i = i + 1) begin : prefix_distance_2
            if (i >= 2) begin : combine
                assign p2[i] = p1[i] & p1[i-2];
                assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
            end else begin : pass_through
                assign p2[i] = p1[i];
                assign g2[i] = g1[i];
            end
        end
        for (i = 0; i < 8; i = i + 1) begin : prefix_distance_4
            if (i >= 4) begin : combine
                assign p3[i] = p2[i] & p2[i-4];
                assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
            end else begin : pass_through
                assign p3[i] = p2[i];
                assign g3[i] = g2[i];
            end
        end
    endgenerate

    assign result[7:0] = p0 ^ {g3[6:0], 1'b0};
    assign subtract_256 = |neg_offset;
    assign result[8] = g3[7] ^ csa_carry[7] ^ subtract_256;
    assign negative_result = subtract_256 & ~(g3[7] | csa_carry[7]);
    assign result[15:9] = {7{negative_result}};
endmodule
