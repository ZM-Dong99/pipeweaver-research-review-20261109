module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);

// Partial products
wire [15:0] pp [0:7];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin: gen_pp
        assign pp[i] = multiplier[i] ? ({8'b0, multiplicand} << i) : 16'b0;
    end
endgenerate

// Stage 1 wires
wire [15:0] s1_comp1_sum, s1_comp1_carry;
wire [15:0] s1_comp2_sum, s1_comp2_carry;
// Stage 2 wires
wire [15:0] s2_comp1_sum, s2_comp1_carry;
wire [15:0] s2_comp2_sum, s2_comp2_carry;
// Stage 3 wires
wire [15:0] s3_comp1_sum, s3_comp1_carry;
// Stage 4 wires
wire [15:0] s4_comp1_sum, s4_comp1_carry;

compressor_3to2 comp1 (
    .a(pp[0]), .b(pp[1]), .c(pp[2]),
    .sum(s1_comp1_sum), .carry(s1_comp1_carry)
);
compressor_3to2 comp2 (
    .a(pp[3]), .b(pp[4]), .c(pp[5]),
    .sum(s1_comp2_sum), .carry(s1_comp2_carry)
);

compressor_3to2 comp3 (
    .a(s1_comp1_sum), .b(s1_comp1_carry), .c(s1_comp2_sum),
    .sum(s2_comp1_sum), .carry(s2_comp1_carry)
);
compressor_3to2 comp4 (
    .a(s1_comp2_carry), .b(pp[6]), .c(pp[7]),
    .sum(s2_comp2_sum), .carry(s2_comp2_carry)
);

compressor_3to2 comp5 (
    .a(s2_comp1_sum), .b(s2_comp1_carry), .c(s2_comp2_sum),
    .sum(s3_comp1_sum), .carry(s3_comp1_carry)
);

compressor_3to2 comp6 (
    .a(s3_comp1_sum), .b(s3_comp1_carry), .c(s2_comp2_carry),
    .sum(s4_comp1_sum), .carry(s4_comp1_carry)
);

assign product = s4_comp1_sum + s4_comp1_carry;

endmodule

module compressor_3to2 (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule
