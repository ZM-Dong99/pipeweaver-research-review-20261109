module sub_16bit_ref (
    input [15:0] a,
    input [15:0] b,
    output [15:0] diff,
    output overflow
);
    reg [15:0] difference;
    reg ovf;
    integer i;
    reg borrow;
    
    always @(*) begin
        borrow = 0;
        for (i = 0; i < 16; i = i + 1) begin
            difference[i] = a[i] ^ b[i] ^ borrow;
            borrow = (~a[i] & b[i]) | ((~a[i] | b[i]) & borrow);
        end
        
        ovf = (a[15] ^ b[15]) && (difference[15] != a[15]);
    end
    
    assign diff = difference;
    assign overflow = ovf;
endmodule