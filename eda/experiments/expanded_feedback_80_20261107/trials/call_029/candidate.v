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
            wire [9:0] result1, result2;
            wire [9:0] selected;

            addr_calcu_base128_path path1 (
                .address(address), .b(b), .ptr(ptr1), .result(result1)
            );
            addr_calcu_base128_path path2 (
                .address(address), .b(b), .ptr(ptr2), .result(result2)
            );

            assign selected = (control == 1'b1) ? result1 : result2;
            assign count = {{6{selected[9]}}, selected};
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

module addr_calcu_base128_path(
    input [7:0] address,
    input [7:0] b,
    input [7:0] ptr,
    output [9:0] result
);
    wire [7:0] adjusted_ptr;
    wire [7:0] sum_bits, majority_bits, shifted_carry;
    wire [7:0] propagate, generate_bits;
    wire [7:0] propagate1, propagate2;
    wire [7:0] generate1, generate2, generate4;
    wire [7:0] carries;
    wire nonzero_offset;
    wire carry8;

    assign adjusted_ptr = ptr ^ 8'h80;

    // Carry-save compression of three unsigned eight-bit operands.
    assign sum_bits = address ^ b ^ adjusted_ptr;
    assign majority_bits = (address & b) |
                           ((address ^ b) & adjusted_ptr);
    assign shifted_carry = {majority_bits[6:0], 1'b0};

    // Parallel-prefix carry computation for the low eight result bits.
    assign propagate = sum_bits ^ shifted_carry;
    assign generate_bits = sum_bits & shifted_carry;

    assign generate1 = generate_bits |
                       (propagate & {generate_bits[6:0], 1'b0});
    assign propagate1 = propagate & {propagate[6:0], 1'b0};
    assign generate2 = generate1 |
                       (propagate1 & {generate1[5:0], 2'b00});
    assign propagate2 = propagate1 & {propagate1[5:0], 2'b00};
    assign generate4 = generate2 |
                       (propagate2 & {generate2[3:0], 4'b0000});

    assign carries = {generate4[6:0], 1'b0};
    assign carry8 = generate4[7];
    assign nonzero_offset = (ptr != 8'h80);

    assign result[7:0] = propagate ^ carries;
    assign result[8] = majority_bits[7] ^ carry8 ^ nonzero_offset;
    assign result[9] = nonzero_offset & ~(majority_bits[7] | carry8);
endmodule
