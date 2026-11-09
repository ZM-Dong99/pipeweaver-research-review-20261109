module sub_32bit_ds (
    input [31:0] a,
    input [31:0] b,
    output [31:0] diff,
    output overflow
);
    wire [31:0] b_comp = ~b + 1'b1;
    wire [32:0] sum = {1'b0, a} + {1'b0, b_comp};
    
    assign diff = sum[31:0];
    assign overflow = (a[31] ^ b[31]) && (sum[31] != a[31]);
endmodule