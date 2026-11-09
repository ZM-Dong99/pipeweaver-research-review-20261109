module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    generate
        if (base == 8'd128) begin : g_base128
            wire [9:0] sum1, sum2;
            wire wrap1, wrap2;
            wire neg1, neg2;
            wire [15:0] count1, count2;

            addr_calcu_sum3_8 u_sum1 (
                .a(address), .b(b), .d(ptr1), .s(sum1)
            );
            addr_calcu_sum3_8 u_sum2 (
                .a(address), .b(b), .d(ptr2), .s(sum2)
            );

            assign wrap1 = ptr1[7] & (|ptr1[6:0]);
            assign wrap2 = ptr2[7] & (|ptr2[6:0]);

            assign neg1 = ~sum1[9] &
                          ((~sum1[8] & ~sum1[7]) |
                           (wrap1 & (~sum1[8] | ~sum1[7])));
            assign neg2 = ~sum2[9] &
                          ((~sum2[8] & ~sum2[7]) |
                           (wrap2 & (~sum2[8] | ~sum2[7])));

            assign count1 = {{7{neg1}},
                             (sum1[8] ^ ~sum1[7] ^ wrap1),
                             ~sum1[7], sum1[6:0]};
            assign count2 = {{7{neg2}},
                             (sum2[8] ^ ~sum2[7] ^ wrap2),
                             ~sum2[7], sum2[6:0]};

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

module addr_calcu_sum3_8(
    input [7:0] a,
    input [7:0] b,
    input [7:0] d,
    output [9:0] s
);
    wire [7:0] x, y;
    wire [8:0] p, g;
    wire [2:0] gp, gg;
    wire [9:0] c;

    assign x = a ^ b ^ d;
    assign y = (a & b) | (a & d) | (b & d);
    assign p = {1'b0, x} ^ {y, 1'b0};
    assign g = {1'b0, x} & {y, 1'b0};

    genvar k;
    generate
        for (k = 0; k < 3; k = k + 1) begin : g_group
            assign gp[k] = p[3*k+2] & p[3*k+1] & p[3*k];
            assign gg[k] = g[3*k+2] |
                           (p[3*k+2] & g[3*k+1]) |
                           (p[3*k+2] & p[3*k+1] & g[3*k]);
            assign c[3*k+1] = g[3*k] | (p[3*k] & c[3*k]);
            assign c[3*k+2] = g[3*k+1] |
                              (p[3*k+1] & g[3*k]) |
                              (p[3*k+1] & p[3*k] & c[3*k]);
        end
    endgenerate

    assign c[0] = 1'b0;
    assign c[3] = gg[0];
    assign c[6] = gg[1] | (gp[1] & gg[0]);
    assign c[9] = gg[2] | (gp[2] & gg[1]) |
                  (gp[2] & gp[1] & gg[0]);
    assign s = {c[9], (p ^ c[8:0])};
endmodule
