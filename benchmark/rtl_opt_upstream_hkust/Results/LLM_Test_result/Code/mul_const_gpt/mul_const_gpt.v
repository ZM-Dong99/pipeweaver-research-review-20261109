module mul_const_gpt
#(  parameter       BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    input [BW-1:0] c,
    output reg [BW-1:0] s1,
    output reg [BW-1:0] s2,
    output reg [BW-1:0] s3
);

always @* begin
    s1 = a << 2;  // Optimized multiplication by 4 using shift
    s2 = (b << 2) + b; // Optimized multiplication by 5 using shift and addition
    s3 = (c << 3) + (c << 1); // Optimized multiplication by 9 using shifts
end
endmodule