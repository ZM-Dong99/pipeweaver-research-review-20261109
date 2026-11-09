module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);
    wire [15:0] row0;
    wire [15:0] row1;
    wire [15:0] row2;
    wire [15:0] row3;
    wire [15:0] row4;
    wire [15:0] row5;
    wire [15:0] row6;
    wire [15:0] row7;

    assign row0 = {8'b0, multiplicand & {8{multiplier[0]}}};
    assign row1 = {8'b0, multiplicand & {8{multiplier[1]}}} << 1;
    assign row2 = {8'b0, multiplicand & {8{multiplier[2]}}} << 2;
    assign row3 = {8'b0, multiplicand & {8{multiplier[3]}}} << 3;
    assign row4 = {8'b0, multiplicand & {8{multiplier[4]}}} << 4;
    assign row5 = {8'b0, multiplicand & {8{multiplier[5]}}} << 5;
    assign row6 = {8'b0, multiplicand & {8{multiplier[6]}}} << 6;
    assign row7 = {8'b0, multiplicand & {8{multiplier[7]}}} << 7;

    wire [15:0] level1_0;
    wire [15:0] level1_1;
    wire [15:0] level1_2;
    wire [15:0] level1_3;
    wire [15:0] level2_0;
    wire [15:0] level2_1;
    wire [15:0] level3_0;

    assign level1_0 = row0 + row1;
    assign level1_1 = row2 + row3;
    assign level1_2 = row4 + row5;
    assign level1_3 = row6 + row7;
    assign level2_0 = level1_0 + level1_1;
    assign level2_1 = level1_2 + level1_3;
    assign level3_0 = level2_0 + level2_1;
    assign product = level3_0;
endmodule
