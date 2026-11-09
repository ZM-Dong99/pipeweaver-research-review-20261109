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

assign pp0 = {8'b0, multiplicand & {8{multiplier[0]}}};
assign pp1 = {8'b0, multiplicand & {8{multiplier[1]}}} << 1;
assign pp2 = {8'b0, multiplicand & {8{multiplier[2]}}} << 2;
assign pp3 = {8'b0, multiplicand & {8{multiplier[3]}}} << 3;
assign pp4 = {8'b0, multiplicand & {8{multiplier[4]}}} << 4;
assign pp5 = {8'b0, multiplicand & {8{multiplier[5]}}} << 5;
assign pp6 = {8'b0, multiplicand & {8{multiplier[6]}}} << 6;
assign pp7 = {8'b0, multiplicand & {8{multiplier[7]}}} << 7;

wire [15:0] sum01;
wire [15:0] sum23;
wire [15:0] sum45;
wire [15:0] sum67;
wire [15:0] sum0123;
wire [15:0] sum4567;

assign sum01 = pp0 + pp1;
assign sum23 = pp2 + pp3;
assign sum45 = pp4 + pp5;
assign sum67 = pp6 + pp7;
assign sum0123 = sum01 + sum23;
assign sum4567 = sum45 + sum67;
assign product = sum0123 + sum4567;

endmodule
