module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);

wire [15:0] partial0;
wire [15:0] partial1;
wire [15:0] partial2;
wire [15:0] partial3;
wire [15:0] partial4;
wire [15:0] partial5;
wire [15:0] partial6;
wire [15:0] partial7;

assign partial0 = {8'b0, (multiplicand & {8{multiplier[0]}})} << 0;
assign partial1 = {8'b0, (multiplicand & {8{multiplier[1]}})} << 1;
assign partial2 = {8'b0, (multiplicand & {8{multiplier[2]}})} << 2;
assign partial3 = {8'b0, (multiplicand & {8{multiplier[3]}})} << 3;
assign partial4 = {8'b0, (multiplicand & {8{multiplier[4]}})} << 4;
assign partial5 = {8'b0, (multiplicand & {8{multiplier[5]}})} << 5;
assign partial6 = {8'b0, (multiplicand & {8{multiplier[6]}})} << 6;
assign partial7 = {8'b0, (multiplicand & {8{multiplier[7]}})} << 7;

wire [15:0] sum01;
wire [15:0] sum23;
wire [15:0] sum45;
wire [15:0] sum67;
wire [15:0] sum0123;
wire [15:0] sum4567;

assign sum01 = partial0 + partial1;
assign sum23 = partial2 + partial3;
assign sum45 = partial4 + partial5;
assign sum67 = partial6 + partial7;
assign sum0123 = sum01 + sum23;
assign sum4567 = sum45 + sum67;
assign product = sum0123 + sum4567;

endmodule
