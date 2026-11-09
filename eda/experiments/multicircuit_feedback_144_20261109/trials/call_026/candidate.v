module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);

wire [7:0]  row0;
wire [8:0]  row1;
wire [9:0]  row2;
wire [10:0] row3;
wire [11:0] row4;
wire [12:0] row5;
wire [13:0] row6;
wire [14:0] row7;

assign row0 = multiplicand & {8{multiplier[0]}};
assign row1 = {1'b0, multiplicand & {8{multiplier[1]}}} << 1;
assign row2 = {2'b0, multiplicand & {8{multiplier[2]}}} << 2;
assign row3 = {3'b0, multiplicand & {8{multiplier[3]}}} << 3;
assign row4 = {4'b0, multiplicand & {8{multiplier[4]}}} << 4;
assign row5 = {5'b0, multiplicand & {8{multiplier[5]}}} << 5;
assign row6 = {6'b0, multiplicand & {8{multiplier[6]}}} << 6;
assign row7 = {7'b0, multiplicand & {8{multiplier[7]}}} << 7;

wire [9:0]  sum01;
wire [11:0] sum23;
wire [13:0] sum45;
wire [15:0] sum67;
wire [11:0] sum0123;
wire [15:0] sum4567;

assign sum01   = {2'b0, row0} + {1'b0, row1};
assign sum23   = {2'b0, row2} + {1'b0, row3};
assign sum45   = {2'b0, row4} + {1'b0, row5};
assign sum67   = {2'b0, row6} + {1'b0, row7};
assign sum0123 = {2'b0, sum01} + sum23;
assign sum4567 = {2'b0, sum45} + sum67;
assign product  = {4'b0, sum0123} + sum4567;

endmodule
