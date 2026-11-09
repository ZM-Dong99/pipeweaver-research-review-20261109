module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    wire [7:0] complemented_offset1, complemented_offset2;
    wire [7:0] address_b_xor, address_b_generate;
    wire [15:0] count1, count2;

    // Eight-bit modular identity: ~(base - ptr) = ptr + ~base.
    assign complemented_offset1 = ptr1 + (~base);
    assign complemented_offset2 = ptr2 + (~base);
    assign address_b_xor = address ^ b;
    assign address_b_generate = address & b;

    addr_calcu_lane lane1 (
        .ab_xor(address_b_xor),
        .ab_generate(address_b_generate),
        .complemented_offset(complemented_offset1),
        .result(count1)
    );
    addr_calcu_lane lane2 (
        .ab_xor(address_b_xor),
        .ab_generate(address_b_generate),
        .complemented_offset(complemented_offset2),
        .result(count2)
    );

    assign count = (control == 1'b1) ? count1 : count2;
endmodule

module addr_calcu_lane(
    input [7:0] ab_xor,
    input [7:0] ab_generate,
    input [7:0] complemented_offset,
    output [15:0] result
);
    wire [7:0] sum_save, majority;
    wire [7:0] shifted_majority;
    wire [7:0] p0, g0, p1, g1, p2, g2, p3, g3;
    wire [8:0] carry;
    wire [7:0] low_result;
    wire bit8_result, negative_result;

    // Compress address + b + complemented_offset without carry propagation.
    assign sum_save = ab_xor ^ complemented_offset;
    assign majority = ab_generate | (ab_xor & complemented_offset);
    assign shifted_majority = {majority[6:0], 1'b0};
    assign p0 = sum_save ^ shifted_majority;
    assign g0 = sum_save & shifted_majority;

    // Parallel-prefix carry calculation, with carry-in one.
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : prefix
            if (i >= 1) begin : distance1
                assign p1[i] = p0[i] & p0[i-1];
                assign g1[i] = g0[i] | (p0[i] & g0[i-1]);
            end else begin : pass1
                assign p1[i] = p0[i];
                assign g1[i] = g0[i];
            end
            if (i >= 2) begin : distance2
                assign p2[i] = p1[i] & p1[i-2];
                assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
            end else begin : pass2
                assign p2[i] = p1[i];
                assign g2[i] = g1[i];
            end
            if (i >= 4) begin : distance4
                assign p3[i] = p2[i] & p2[i-4];
                assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
            end else begin : pass4
                assign p3[i] = p2[i];
                assign g3[i] = g2[i];
            end
            assign carry[i+1] = g3[i] | p3[i];
        end
    endgenerate
    assign carry[0] = 1'b1;
    assign low_result = p0 ^ carry[7:0];

    // T = address + b + complemented_offset + 1.
    // The required result is T - 256, modulo 65536.
    assign bit8_result = ~(majority[7] ^ carry[8]);
    assign negative_result = ~(majority[7] | carry[8]);
    assign result = {{7{negative_result}}, bit8_result, low_result};
endmodule
