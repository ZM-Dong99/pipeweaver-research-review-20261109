module calculation_gpt
#(  parameter       BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    input [BW-1:0] c,
    input [BW-1:0] d,
    output [BW-1:0] s1,
    output [BW-1:0] s2,
    output [BW-1:0] s3,
    output [BW-1:0] s4,
    output [BW-1:0] s5,
    output [BW-1:0] s6
);

    wire [BW-1:0] mul_ab = a * b;
    wire [BW-1:0] sum_ab = a + b;
    wire [BW-1:0] sum_cd = c + d;
    
    assign s1 = sum_ab;
    assign s2 = mul_ab;
    assign s3 = (a % b) + d;
    assign s4 = sum_cd + mul_ab;
    assign s5 = a - b;
    assign s6 = (mul_ab + d + c) - b + (b + 1);

endmodule