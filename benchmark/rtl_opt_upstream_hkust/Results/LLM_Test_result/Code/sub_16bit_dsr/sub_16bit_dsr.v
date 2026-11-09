module sub_16bit_dsr (
    input [15:0] a,
    input [15:0] b,
    output [15:0] diff,
    output overflow
);

    assign diff = a - b;
    assign overflow = (a[15] ^ b[15]) & (diff[15] ^ a[15]);
endmodule