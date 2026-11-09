module sub_16bit_mini (
    input [15:0] a,
    input [15:0] b,
    output [15:0] diff,
    output overflow
);

    wire [16:0] result;

    assign result = {a[15], a} - {b[15], b};

    assign diff = result[15:0];
    assign overflow = (result[16] != result[15]);

endmodule