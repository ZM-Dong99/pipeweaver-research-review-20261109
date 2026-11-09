module addr_calcu(
    input [7:0] address,
    input [7:0] ptr1, ptr2,
    input [7:0] b,
    input control,
    output [15:0] count
);
    parameter [7:0] base = 8'b10000000;

    wire [7:0] ptr;
    assign ptr = control ? ptr1 : ptr2;

    generate
        if (base == 8'h80) begin : g_base128
            wire [7:0] s, majority;
            wire [7:0] u, v;
            wire [7:0] propagate, genbit;
            wire [8:0] carry;
            wire [7:0] low_result;
            wire wrap_offset, subtract_high;
            wire negative_if_no_carry, negative_if_carry;
            wire negative_result, bit8;

            // Carry-save representation of address + b + ptr.
            assign s = address ^ b ^ ptr;
            assign majority = (address & b) |
                              (address & ptr) |
                              (b & ptr);

            // Inverting bit 7 subtracts 128, with a correction
            // of -256 when the original s[7] was zero.
            assign u = {~s[7], s[6:0]};
            assign v = {majority[6:0], 1'b0};
            assign propagate = u ^ v;
            assign genbit = u & v;

            // Short grouped carry-lookahead network. Bit zero
            // has no second operand and cannot generate a carry.
            assign carry[0] = 1'b0;
            assign carry[1] = 1'b0;
            assign carry[2] = genbit[1];
            assign carry[3] = genbit[2] |
                              (propagate[2] & genbit[1]);
            assign carry[4] = genbit[3] |
                              (propagate[3] & genbit[2]) |
                              (propagate[3] & propagate[2] & genbit[1]);
            assign carry[5] = genbit[4] |
                              (propagate[4] & carry[4]);
            assign carry[6] = genbit[5] |
                              (propagate[5] & genbit[4]) |
                              (propagate[5] & propagate[4] & carry[4]);
            assign carry[7] = genbit[6] |
                              (propagate[6] & carry[6]);
            assign carry[8] = genbit[7] |
                              (propagate[7] & genbit[6]) |
                              (propagate[7] & propagate[6] & carry[6]);
            assign low_result = propagate ^ carry[7:0];

            // The original eight-bit offset wraps when ptr > 128.
            // Upper result, in units of 256, is:
            // majority[7] + carry[8] - (~s[7]) - wrap_offset.
            assign wrap_offset = ptr[7] & (|ptr[6:0]);
            assign subtract_high = ~s[7];
            assign negative_if_no_carry =
                ((~majority[7]) & (subtract_high | wrap_offset)) |
                (subtract_high & wrap_offset);
            assign negative_if_carry =
                (~majority[7]) & subtract_high & wrap_offset;
            assign negative_result = carry[8] ?
                negative_if_carry : negative_if_no_carry;
            assign bit8 = majority[7] ^ carry[8] ^
                          subtract_high ^ wrap_offset;

            assign count = {{7{negative_result}}, bit8, low_result};
        end else begin : g_other_base
            wire [7:0] offset;
            wire [8:0] sum_ab;
            wire [9:0] difference;
            assign offset = base - ptr;
            assign sum_ab = {1'b0, address} + {1'b0, b};
            assign difference = {1'b0, sum_ab} - {2'b00, offset};
            assign count = {{6{difference[9]}}, difference};
        end
    endgenerate
endmodule
