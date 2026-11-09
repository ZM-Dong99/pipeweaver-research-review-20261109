module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);

wire [15:0] pp0;
wire [15:0] pp1;
wire [15:0] pp2;
wire [15:0] pp3;
wire [15:0] pp4;
wire [15:0] pp5;
wire [15:0] pp6;
wire [15:0] pp7;

assign pp0 = {8'b0, (multiplier & {8{multiplicand[0]}})};
assign pp1 = {8'b0, (multiplier & {8{multiplicand[1]}})} << 1;
assign pp2 = {8'b0, (multiplier & {8{multiplicand[2]}})} << 2;
assign pp3 = {8'b0, (multiplier & {8{multiplicand[3]}})} << 3;
assign pp4 = {8'b0, (multiplier & {8{multiplicand[4]}})} << 4;
assign pp5 = {8'b0, (multiplier & {8{multiplicand[5]}})} << 5;
assign pp6 = {8'b0, (multiplier & {8{multiplicand[6]}})} << 6;
assign pp7 = {8'b0, (multiplier & {8{multiplicand[7]}})} << 7;

wire [15:0] level1_0;
wire [15:0] level1_1;
wire [15:0] level1_2;
wire [15:0] level1_3;
wire [15:0] level2_0;
wire [15:0] level2_1;
wire [15:0] level3;

assign level1_0 = pp0 + pp1;
assign level1_1 = pp2 + pp3;
assign level1_2 = pp4 + pp5;
assign level1_3 = pp6 + pp7;
assign level2_0 = level1_0 + level1_1;
assign level2_1 = level1_2 + level1_3;
assign level3 = level2_0 + level2_1;
assign product = level3;

endmodule
