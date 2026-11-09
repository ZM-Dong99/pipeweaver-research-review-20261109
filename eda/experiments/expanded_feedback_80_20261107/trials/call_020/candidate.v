module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    generate
        if (base == 8'h80) begin : g_base128
            wire [7:0] ab_xor, ab_and;
            wire [15:0] count1, count2;
            assign ab_xor = address ^ b;
            assign ab_and = address & b;

            addr_calcu_lane128 lane1 (
                .ab_xor(ab_xor), .ab_and(ab_and),
                .ptr(ptr1), .result(count1)
            );
            addr_calcu_lane128 lane2 (
                .ab_xor(ab_xor), .ab_and(ab_and),
                .ptr(ptr2), .result(count2)
            );
            assign count = (control == 1'b1) ? count1 : count2;
        end else begin : g_other_base
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

module addr_calcu_lane128(
    input [7:0] ab_xor,
    input [7:0] ab_and,
    input [7:0] ptr,
    output [15:0] result
);
    wire [7:0] adjusted_ptr;
    wire [7:0] cs_sum, cs_carry;
    wire [7:0] shifted_carry;
    wire [7:0] p, g;
    wire [3:0] group_p, group_g;
    wire [8:0] c;
    wire [7:0] low_result;
    wire subtract_256;
    wire upper_bit, negative;

    assign adjusted_ptr = {~ptr[7], ptr[6:0]};
    assign cs_sum = ab_xor ^ adjusted_ptr;
    assign cs_carry = ab_and | (ab_xor & adjusted_ptr);
    assign shifted_carry = {cs_carry[6:0], 1'b0};
    assign p = cs_sum ^ shifted_carry;
    assign g = cs_sum & shifted_carry;

    assign group_p[0] = p[1] & p[0];
    assign group_p[1] = p[3] & p[2];
    assign group_p[2] = p[5] & p[4];
    assign group_p[3] = p[7] & p[6];
    assign group_g[0] = g[1] | (p[1] & g[0]);
    assign group_g[1] = g[3] | (p[3] & g[2]);
    assign group_g[2] = g[5] | (p[5] & g[4]);
    assign group_g[3] = g[7] | (p[7] & g[6]);

    assign c[0] = 1'b0;
    assign c[1] = g[0];
    assign c[2] = group_g[0];
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = group_g[1]
                | (group_p[1] & group_g[0]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = group_g[2]
                | (group_p[2] & group_g[1])
                | (group_p[2] & group_p[1] & group_g[0]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = group_g[3]
                | (group_p[3] & group_g[2])
                | (group_p[3] & group_p[2] & group_g[1])
                | (group_p[3] & group_p[2] & group_p[1] & group_g[0]);

    assign low_result = p ^ c[7:0];
    assign subtract_256 = ~(ptr[7] & (~|ptr[6:0]));
    assign upper_bit = c[8] ^ cs_carry[7] ^ subtract_256;
    assign negative = subtract_256 & ~(c[8] | cs_carry[7]);
    assign result = {{7{negative}}, upper_bit, low_result};
endmodule
