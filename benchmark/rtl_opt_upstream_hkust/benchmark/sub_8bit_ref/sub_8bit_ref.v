module sub_8bit_ref (
    input [7:0] a,
    input [7:0] b,
    output [7:0] diff,
    output overflow
);
    
    wire [8:0] extended_diff = {a[7], a} - {b[7], b};

    assign diff = extended_diff[7:0];
    assign overflow = (extended_diff[8] != extended_diff[7]);
    
endmodule