module sub_32bit_ref (
    input [31:0] a,
    input [31:0] b,
    output [31:0] diff,
    output overflow
);
  
    wire [32:0] extended_diff = {a[31], a} - {b[31], b};
    
    assign diff = extended_diff[31:0];
    assign overflow = (extended_diff[32] != extended_diff[31]);
endmodule