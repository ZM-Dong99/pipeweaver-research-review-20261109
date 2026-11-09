module sub_32bit_mini (
    input [31:0] a,
    input [31:0] b,
    output [31:0] diff,
    output overflow
);
    // 32-bit subtraction using two's complement arithmetic
    // a - b = a + (-b)
    // -b is the two's complement of b, which is ~b + 1
    wire [31:0] b_twos_comp = ~b + 1;
    wire [32:0] sum = {1'b0, a} + {1'b0, b_twos_comp}; // Add with carry out
    
    assign diff = sum[31:0];
    
    // Overflow detection for a - b
    // Overflow occurs if:
    // 1. a > 0, b < 0, and diff < 0
    // 2. a < 0, b > 0, and diff > 0
    // This is equivalent to checking if the sign of a and b are different, and the sign of the result is different from the sign of a.
    assign overflow = (a[31] != b[31]) && (sum[31] != a[31]);

endmodule