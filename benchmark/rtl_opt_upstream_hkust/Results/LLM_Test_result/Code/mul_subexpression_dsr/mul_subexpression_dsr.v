module mul_subexpression_dsr(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);

wire [7:0] partial_products [0:7];
genvar i, j;
generate
    for (i = 0; i < 8; i = i + 1) begin: gen_rows
        for (j = 0; j < 8; j = j + 1) begin: gen_cols
            assign partial_products[i][j] = multiplicand[i] & multiplier[j];
        end
    end
endgenerate

wire [15:0] shifted_partial [0:7];
generate
    for (i = 0; i < 8; i = i + 1) begin: shift_gen
        assign shifted_partial[i] = {8'b0, partial_products[i]} << i;
    end
endgenerate

wire [15:0] l1_sum0 = shifted_partial[0] + shifted_partial[1];
wire [15:0] l1_sum1 = shifted_partial[2] + shifted_partial[3];
wire [15:0] l1_sum2 = shifted_partial[4] + shifted_partial[5];
wire [15:0] l1_sum3 = shifted_partial[6] + shifted_partial[7];

wire [15:0] l2_sum0 = l1_sum0 + l1_sum1;
wire [15:0] l2_sum1 = l1_sum2 + l1_sum3;

assign product = l2_sum0 + l2_sum1;

endmodule