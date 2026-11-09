module mul_subexpression_gpt(
    input [7:0] multiplicand,  // 8-bit multiplicand
    input [7:0] multiplier,    // 8-bit multiplier
    output [15:0] product      // 16-bit product output
);

wire [15:0] partial_products[7:0];

genvar i, j;
generate
    for (i = 0; i < 8; i = i + 1) begin: gen_rows
        assign partial_products[i] = multiplicand[i] ? (multiplier << i) : 16'b0;
    end
endgenerate

// The final product is the sum of all the partial products
assign product = partial_products[0] + partial_products[1] +
                 partial_products[2] + partial_products[3] +
                 partial_products[4] + partial_products[5] +
                 partial_products[6] + partial_products[7];

endmodule