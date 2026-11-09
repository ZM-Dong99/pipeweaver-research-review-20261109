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
            wire [7:0] ab_xor;
            wire [7:0] ab_and;
            wire [15:0] result1, result2;
            assign ab_xor = address ^ b;
            assign ab_and = address & b;

            genvar lane;
            for (lane = 0; lane < 2; lane = lane + 1) begin : paths
                wire [7:0] ptr;
                wire [7:0] cs_sum, cs_carry;
                wire [7:0] u, v, p, g;
                wire [3:0] gp, gg;
                wire [8:0] carry;
                wire [7:0] low_result;
                wire greater_than_base;
                wire high_parity, high_majority;
                wire negative_result, result_bit8;
                wire [15:0] result;

                assign ptr = (lane == 0) ? ptr1 : ptr2;
                assign cs_sum = ab_xor ^ ptr;
                assign cs_carry = ab_and | (ab_xor & ptr);

                // Add 128 to the carry-save sum without a separate adder.
                // Its displaced bit is accounted for in the upper result.
                assign u = {~cs_sum[7], cs_sum[6:0]};
                assign v = {cs_carry[6:0], 1'b0};
                assign p = u ^ v;
                assign g = u & v;

                assign gp[0] = p[1] & p[0];
                assign gp[1] = p[3] & p[2];
                assign gp[2] = p[5] & p[4];
                assign gp[3] = p[7] & p[6];
                assign gg[0] = g[1] | (p[1] & g[0]);
                assign gg[1] = g[3] | (p[3] & g[2]);
                assign gg[2] = g[5] | (p[5] & g[4]);
                assign gg[3] = g[7] | (p[7] & g[6]);

                assign carry[0] = 1'b0;
                assign carry[2] = gg[0];
                assign carry[4] = gg[1] | (gp[1] & gg[0]);
                assign carry[6] = gg[2] | (gp[2] & gg[1])
                                | (gp[2] & gp[1] & gg[0]);
                assign carry[8] = gg[3] | (gp[3] & gg[2])
                                | (gp[3] & gp[2] & gg[1])
                                | (gp[3] & gp[2] & gp[1] & gg[0]);
                assign carry[1] = g[0];
                assign carry[3] = g[2] | (p[2] & carry[2]);
                assign carry[5] = g[4] | (p[4] & carry[4]);
                assign carry[7] = g[6] | (p[6] & carry[6]);
                assign low_result = p ^ carry[7:0];

                assign greater_than_base = ptr[7] & (|ptr[6:0]);
                assign high_parity = cs_sum[7] ^ cs_carry[7] ^ carry[8];
                assign high_majority = (cs_sum[7] & cs_carry[7])
                                     | (cs_sum[7] & carry[8])
                                     | (cs_carry[7] & carry[8]);
                assign result_bit8 = high_parity ^ ~greater_than_base;
                assign negative_result = ~(cs_sum[7] | cs_carry[7] | carry[8])
                                       | (greater_than_base & ~high_majority);
                assign result = {{7{negative_result}}, result_bit8, low_result};

                if (lane == 0) begin : first
                    assign result1 = result;
                end else begin : second
                    assign result2 = result;
                end
            end
            assign count = (control == 1'b1) ? result1 : result2;
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
