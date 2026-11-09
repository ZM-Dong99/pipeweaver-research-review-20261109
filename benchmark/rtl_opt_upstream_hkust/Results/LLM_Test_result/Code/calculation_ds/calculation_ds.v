module calculation_ds
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

    wire [BW-1:0] a_plus_b = a + b;
    wire [BW-1:0] a_mul_b = a * b;
    wire [BW-1:0] a_mod_b = a % b;
    wire [BW-1:0] b_plus_1 = b + 1'b1;

    assign s1 = a_plus_b;
    assign s2 = a_mul_b;
    assign s3 = a_mod_b + d;
    assign s4 = c + d + a_mul_b;
    assign s5 = a - b;
    assign s6 = (b_plus_1 * a) + d + c - b;
endmodule