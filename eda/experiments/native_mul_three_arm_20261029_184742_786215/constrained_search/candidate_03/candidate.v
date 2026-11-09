module mul_subexpression(input [7:0] multiplicand, input [7:0] multiplier, output [15:0] product);
wire [15:0] r0 = {8'b0, (multiplicand & {8{multiplier[0]}})} << 0;
wire [15:0] r1 = {8'b0, (multiplicand & {8{multiplier[1]}})} << 1;
wire [15:0] r2 = {8'b0, (multiplicand & {8{multiplier[2]}})} << 2;
wire [15:0] r3 = {8'b0, (multiplicand & {8{multiplier[3]}})} << 3;
wire [15:0] r4 = {8'b0, (multiplicand & {8{multiplier[4]}})} << 4;
wire [15:0] r5 = {8'b0, (multiplicand & {8{multiplier[5]}})} << 5;
wire [15:0] r6 = {8'b0, (multiplicand & {8{multiplier[6]}})} << 6;
wire [15:0] r7 = {8'b0, (multiplicand & {8{multiplier[7]}})} << 7;
wire [15:0] s0 = r0 + r2;
wire [15:0] s1 = r1 + r3;
wire [15:0] s2 = r4 + r6;
wire [15:0] s3 = r5 + r7;
wire [15:0] s4 = s0 + s1;
wire [15:0] s5 = s2 + s3;
wire [15:0] s6 = s4 + s5;
assign product = s6;
endmodule
