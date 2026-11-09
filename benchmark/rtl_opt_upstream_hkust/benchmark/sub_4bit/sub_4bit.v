module sub_4bit (
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff,
    output overflow
);
    reg [3:0] difference;
    reg ovf;
    integer i;
    reg borrow;
    
    always @(*) begin
        borrow = 0;
        for (i = 0; i < 4; i = i + 1) begin
            difference[i] = a[i] ^ b[i] ^ borrow;
            borrow = (~a[i] & b[i]) | ((~a[i] | b[i]) & borrow);
        end
        
        
        ovf = (a[3] ^ b[3]) && (difference[3] != a[3]);
    end
    
    assign diff = difference;
    assign overflow = ovf;
endmodule