module sub_16bit_gpt (
    input [15:0] a,
    input [15:0] b,
    output [15:0] diff,
    output overflow
);

    wire [16:0] extended_diff;

    assign extended_diff = {a[15], a} - {b[15], b};
    
    assign diff = extended_diff[15:0];
    assign overflow = extended_diff[16] ^ extended_diff[15];
endmodule