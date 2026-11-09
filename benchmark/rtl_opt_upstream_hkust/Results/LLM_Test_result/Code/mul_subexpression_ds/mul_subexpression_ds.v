module mul_subexpression_ds(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);

wire [7:0] pp0 = {8{multiplier[0]}} & multiplicand;
wire [7:0] pp1 = {8{multiplier[1]}} & multiplicand;
wire [7:0] pp2 = {8{multiplier[2]}} & multiplicand;
wire [7:0] pp3 = {8{multiplier[3]}} & multiplicand;
wire [7:0] pp4 = {8{multiplier[4]}} & multiplicand;
wire [7:0] pp5 = {8{multiplier[5]}} & multiplicand;
wire [7:0] pp6 = {8{multiplier[6]}} & multiplicand;
wire [7:0] pp7 = {8{multiplier[7]}} & multiplicand;

wire [15:0] sum0 = {8'b0, pp0};
wire [15:0] sum1 = sum0 + ({7'b0, pp1, 1'b0});
wire [15:0] sum2 = sum1 + ({6'b0, pp2, 2'b0});
wire [15:0] sum3 = sum2 + ({5'b0, pp3, 3'b0});
wire [15:0] sum4 = sum3 + ({4'b0, pp4, 4'b0});
wire [15:0] sum5 = sum4 + ({3'b0, pp5, 5'b0});
wire [15:0] sum6 = sum5 + ({2'b0, pp6, 6'b0});
wire [15:0] sum7 = sum6 + ({1'b0, pp7, 7'b0});

assign product = sum7;

endmodule