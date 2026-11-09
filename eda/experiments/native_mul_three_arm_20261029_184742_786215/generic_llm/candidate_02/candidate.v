module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);

    assign product = multiplicand * multiplier;

endmodule
