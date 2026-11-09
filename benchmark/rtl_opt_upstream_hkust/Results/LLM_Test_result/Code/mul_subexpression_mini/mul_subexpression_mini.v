module mul_subexpression_mini(
    input [7:0] multiplicand,  // 8-bit multiplicand
    input [7:0] multiplier,    // 8-bit multiplier
    output [15:0] product      // 16-bit product output
);

// Standard multiplier for signed/unsigned operations
// This directly infers a dedicated multiplier block if available or
// an optimized combination of adders/logic by the synthesis tool.
// It is significantly more efficient in terms of PPA compared to
// bit-level partial product generation and summation described in the original code.
assign product = multiplicand * multiplier;

endmodule