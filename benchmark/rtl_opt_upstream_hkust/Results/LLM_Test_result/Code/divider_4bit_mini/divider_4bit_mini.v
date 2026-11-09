module divider_4bit_mini (
    input wire [3:0] A,
    input wire [1:0] B,
    output wire [3:0] result,
    output wire [3:0] odd
);

wire [5:0] dividend = {2'b0, A}; // Zero-extend dividend to 6 bits
wire [3:0] divisor  = {2'b0, B}; // Zero-extend divisor to 4 bits

// 4-bit unsigned division and modulo using built-in operators
// Synthesis tools are generally highly optimized for this.
assign {odd[1:0], odd[3:2]} = dividend % divisor; // Modulo for remainder (odd)
assign {result[1:0], result[3:2]} = dividend / divisor; // Division for quotient (result)

// The original code returned a 4-bit quotient and a 4-bit remainder.
// Since the divisor is 2 bits, the maximum remainder is 3 (binary 11).
// The original code's "odd" output is 4 bits wide, but only the lower 2 bits are meaningful
// for the remainder of a 4-bit by 2-bit division.
// Similarly, the maximum quotient is 15 for A=15, B=1. This also fits in 4 bits.
// The original logic seems to implement a restoring division, but the use of temp[7]
// to determine addition vs subtraction is unusual and likely incorrect for standard
// integer division. It also produces a 4-bit remainder which is non-standard for N by M division.
// A standard 4-bit by 2-bit unsigned division should produce a 4-bit quotient and a 2-bit remainder.
// Assuming the intent was standard unsigned division/modulo:
// The assignment above directly uses Verilog's division/modulo operators
// which are optimized by synthesis tools for standard integer math.
// The {odd[1:0], odd[3:2]} and {result[1:0], result[3:2]} assignments
// map the 2-bit standard remainder and quotient to the specified 4-bit output widths
// with upper bits of 'odd' and 'result' being effectively zero-extended or unused,
// matching the behavior if a standard restoring division was performed and the upper bits
// were zero for valid remainders/quotients.

endmodule