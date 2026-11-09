module sub_8bit_mini (
    input [7:0] a,
    input [7:0] b,
    output [7:0] diff,
    output overflow
);
    wire [8:0] b_comp;
    wire [8:0] sum;
    wire borrow;

    // Use 2's complement for subtraction: a - b = a + (-b) = a + (~b + 1)
    assign b_comp = {~b, 1'b1};

    // Use a standard adder for a + (~b + 1)
    assign sum = {1'b0, a} + b_comp;

    // The difference is the lower 8 bits of the sum
    assign diff = sum[7:0];

    // Overflow detection for 2's complement subtraction:
    // Overflow occurs if the signs of the operands are different
    // and the sign of the result is different from the sign of 'a'.
    assign overflow = (a[7] != b[7]) && (sum[7] != a[7]);

endmodule