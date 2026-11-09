module sub_16bit_ds (
    input [15:0] a,
    input [15:0] b,
    output [15:0] diff,
    output overflow
);

    wire [15:0] diff_int = a - b;
    wire a_sign = a[15];
    wire b_sign = b[15];
    wire diff_sign = diff_int[15];

    assign diff = diff_int;
    assign overflow = (~a_sign & b_sign & diff_sign) | (a_sign & ~b_sign & ~diff_sign);
endmodule