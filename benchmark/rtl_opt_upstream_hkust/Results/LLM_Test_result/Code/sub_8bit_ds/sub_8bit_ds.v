module sub_8bit_ds (
    input [7:0] a,
    input [7:0] b,
    output [7:0] diff,
    output overflow
);
    wire [8:0] full_diff = {1'b0, a} - {1'b0, b};
    
    assign diff = full_diff[7:0];
    assign overflow = (a[7] ^ b[7]) && (diff[7] != a[7]);
endmodule