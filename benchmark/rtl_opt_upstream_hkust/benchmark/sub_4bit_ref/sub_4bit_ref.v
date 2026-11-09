module sub_4bit_ref (
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff,
    output overflow
);

    wire [4:0] extended_diff = {a[3], a} - {b[3], b};
    
    assign diff = extended_diff[3:0];
    assign overflow = (extended_diff[4] != extended_diff[3]);
endmodule