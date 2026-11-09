module sub_4bit_dsr (
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff,
    output overflow
);
    wire [4:0] sum_full;
    
    assign sum_full = a + ~b + 1'b1;
    assign diff = sum_full[3:0];
    assign overflow = (a[3] ^ b[3]) && (sum_full[3] != a[3]);
endmodule