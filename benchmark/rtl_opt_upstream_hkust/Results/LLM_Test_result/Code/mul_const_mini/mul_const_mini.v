module mul_const_mini
#(  parameter       BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    input [BW-1:0] c,
    output wire [BW-1:0] s1,
    output wire [BW-1:0] s2,
    output wire [BW-1:0] s3
);

assign s1 = a << 2; // Multiplying by 4 is a left shift by 2
assign s2 = b * 5; // No simple bit shift for 5
assign s3 = c * 9; // No simple bit shift for 9

endmodule