module sub_4bit_ds (
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff,
    output overflow
);
    wire [3:0] b_comp = ~b;
    wire [4:0] sum = a + b_comp + 1;
    
    assign diff = sum[3:0];
    assign overflow = (a[3] ^ b[3]) && (diff[3] != a[3]);
endmodule