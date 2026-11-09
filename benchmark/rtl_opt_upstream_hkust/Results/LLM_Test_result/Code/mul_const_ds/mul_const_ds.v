module mul_const_ds
#(  parameter       BW = 8)
(
    input [BW-1:0] a,
    input [BW-1:0] b,
    input [BW-1:0] c,
    output [BW-1:0] s1,
    output [BW-1:0] s2,
    output [BW-1:0] s3
);

assign s1 = {a[BW-3:0], 2'b00};  // a * 4
assign s2 = b + {b[BW-3:0], 2'b00};  // b * 5
assign s3 = c + {c[BW-4:0], 3'b000};  // c * 9
endmodule