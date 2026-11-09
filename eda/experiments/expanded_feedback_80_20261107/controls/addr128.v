module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    generate
        if (base == 8'h80) begin : optimized_default
            wire [7:0] ptr;
            wire [6:0] s, c;
            wire [6:0] x, y;
            wire [6:0] p0, g0, p1, g1, p2, g2, p3, g3;
            wire [6:0] low_result;
            wire low_carry;
            wire above_base;
            wire [2:0] high_without_carry;
            wire [2:0] high_with_carry;
            wire [2:0] high_result;

            assign ptr = control ? ptr1 : ptr2;

            // Carry-save addition of the three low-seven-bit operands.
            assign s = address[6:0] ^ b[6:0] ^ ptr[6:0];
            assign c = (address[6:0] & b[6:0]) |
                       (address[6:0] & ptr[6:0]) |
                       (b[6:0] & ptr[6:0]);
            assign x = s;
            assign y = {c[5:0], 1'b0};
            assign p0 = x ^ y;
            assign g0 = x & y;

            // Seven-bit parallel-prefix carry calculation, carry-in zero.
            for (genvar i = 0; i < 7; i = i + 1) begin : prefix
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
            end

            assign low_result = p0 ^ {g3[5:0], 1'b0};
            assign low_carry = g3[6];
            assign above_base = ptr[7] & (|ptr[6:0]);

            // Upper quotient, in units of 128. Precompute both outcomes
            // so the low-part carry selects rather than starts an adder.
            assign high_without_carry =
                {2'b00, address[7]} + {2'b00, b[7]} +
                {2'b00, ptr[7]} + {2'b00, c[6]} -
                3'd1 - (above_base ? 3'd2 : 3'd0);
            assign high_with_carry = high_without_carry + 3'd1;
            assign high_result = low_carry ? high_with_carry :
                                                    high_without_carry;
            assign count = {{6{high_result[2]}}, high_result, low_result};
        end else begin : other_parameters
            wire [7:0] ptr;
            wire [7:0] offset;
            assign ptr = control ? ptr1 : ptr2;
            assign offset = base - ptr;
            assign count = {8'h00, address} - {8'h00, offset}
                         + {8'h00, b};
        end
    endgenerate
endmodule
