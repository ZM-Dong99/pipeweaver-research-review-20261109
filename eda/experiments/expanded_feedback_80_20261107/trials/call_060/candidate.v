module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    generate
        if (base == 8'd128) begin : optimized_base128
            wire [7:0] ptr;
            wire [7:0] cs_sum, cs_majority;
            wire [7:0] x, y;
            wire [7:0] p0, g0;
            wire [7:0] p1, g1;
            wire [7:0] p2, g2;
            wire [7:0] g3;
            wire [7:0] low_result;
            wire correction;
            wire [1:0] upper;

            assign ptr = control ? ptr1 : ptr2;

            // Carry-save representation of address + b + ptr.
            assign cs_sum = address ^ b ^ ptr;
            assign cs_majority = (address & b) |
                                 (address & ptr) |
                                 (b & ptr);

            // Add 128 by complementing bit 7 of the sum row.
            // Its additional carry is the original cs_sum[7].
            assign x = {~cs_sum[7], cs_sum[6:0]};
            assign y = {cs_majority[6:0], 1'b0};
            assign p0 = x ^ y;
            assign g0 = x & y;

            // Eight-bit parallel-prefix carry calculation.
            assign p1 = p0 & {p0[6:0], 1'b0};
            assign g1 = g0 | (p0 & {g0[6:0], 1'b0});
            assign p2 = p1 & {p1[5:0], 2'b00};
            assign g2 = g1 | (p1 & {g1[5:0], 2'b00});
            assign g3 = g2 | (p2 & {g2[3:0], 4'b0000});
            assign low_result = p0 ^ {g3[6:0], 1'b0};

            // count = address + b + ptr - 128
            //         - 256 * (ptr > 128), modulo 65536.
            assign correction = ptr[7] & (|ptr[6:0]);
            assign upper = {1'b0, cs_majority[7]} +
                           {1'b0, cs_sum[7]} +
                           {1'b0, g3[7]} -
                           2'd1 - {1'b0, correction};

            // The full mathematical result lies in [-255, 510].
            assign count = {{6{upper[1]}}, upper, low_result};
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
