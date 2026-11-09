module sub_8bit_dsr (
    input [7:0] a,
    input [7:0] b,
    output [7:0] diff,
    output overflow
);
    wire [8:0] sum = a + ~b + 1'b1;
    assign diff = sum[7:0];
    assign overflow = (a[7] ^ b[7]) & (diff[7] != a[7]);
endmodule