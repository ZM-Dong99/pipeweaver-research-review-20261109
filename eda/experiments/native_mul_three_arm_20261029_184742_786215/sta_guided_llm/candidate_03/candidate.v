module mul_subexpression(
    input [7:0] multiplicand,  // 8-bit multiplicand
    input [7:0] multiplier,    // 8-bit multiplier
    output [15:0] product      // 16-bit product output
);

// Direct unsigned multiplication; operand extended to 16 bits to ensure full product width
assign product = multiplicand * {8'b0, multiplier};

endmodule
