module sub_32bit_dsr (
    input [31:0] a,
    input [31:0] b,
    output [31:0] diff,
    output overflow
);

    wire [32:0] full_sub = {1'b0, a} - {1'b0, b};
    assign diff = full_sub[31:0];
    assign overflow = (a[31] ^ b[31]) && (full_sub[32] ^ full_sub[31]);

endmodule