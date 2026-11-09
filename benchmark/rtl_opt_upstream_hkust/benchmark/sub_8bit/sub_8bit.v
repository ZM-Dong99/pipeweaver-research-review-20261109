module sub_8bit (
    input [7:0] a,
    input [7:0] b,
    output [7:0] diff,
    output overflow
);
    reg [7:0] difference;
    reg ovf;
    integer i;
    reg borrow;
    
    always @(*) begin
        borrow = 0;
        for (i = 0; i < 8; i = i + 1) begin
            difference[i] = a[i] ^ b[i] ^ borrow;
            borrow = (~a[i] & b[i]) | ((~a[i] | b[i]) & borrow);
        end
        
    
        ovf = (a[7] ^ b[7]) && (difference[7] != a[7]);
    end
    
    assign diff = difference;
    assign overflow = ovf;
endmodule