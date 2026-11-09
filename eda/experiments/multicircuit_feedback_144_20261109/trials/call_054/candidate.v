module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);

wire [15:0] multiplicand_ext;
wire [15:0] partial0;
wire [15:0] partial1;
wire [15:0] partial2;
wire [15:0] partial3;
wire [15:0] partial4;
wire [15:0] partial5;
wire [15:0] partial6;
wire [15:0] partial7;
wire [15:0] sum01;
wire [15:0] sum23;
wire [15:0] sum45;
wire [15:0] sum67;
wire [15:0] sum0123;
wire [15:0] sum4567;

assign multiplicand_ext = {8'b0, multiplicand};
assign partial0 = multiplicand_ext & {16{multiplier[0]}};
assign partial1 = (multiplicand_ext << 1) & {16{multiplier[1]}};
assign partial2 = (multiplicand_ext << 2) & {16{multiplier[2]}};
assign partial3 = (multiplicand_ext << 3) & {16{multiplier[3]}};
assign partial4 = (multiplicand_ext << 4) & {16{multiplier[4]}};
assign partial5 = (multiplicand_ext << 5) & {16{multiplier[5]}};
assign partial6 = (multiplicand_ext << 6) & {16{multiplier[6]}};
assign partial7 = (multiplicand_ext << 7) & {16{multiplier[7]}};

assign sum01 = partial0 + partial1;
assign sum23 = partial2 + partial3;
assign sum45 = partial4 + partial5;
assign sum67 = partial6 + partial7;
assign sum0123 = sum01 + sum23;
assign sum4567 = sum45 + sum67;
assign product = sum0123 + sum4567;

endmodule
