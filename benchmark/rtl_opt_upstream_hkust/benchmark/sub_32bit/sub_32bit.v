module sub_32bit (
    input [31:0] a,
    input [31:0] b,
    output [31:0] diff,
    output overflow
);
    reg [31:0] difference;
    reg ovf;
    integer i;
    reg borrow;
    
    always @(*) begin
        borrow = 0;
        for (i = 0; i < 32; i = i + 1) begin
            difference[i] = a[i] ^ b[i] ^ borrow;
            borrow = (~a[i] & b[i]) | ((~a[i] | b[i]) & borrow);
        end
        
        ovf = (a[31] ^ b[31]) && (difference[31] != a[31]);
    end
    
    assign diff = difference;
    assign overflow = ovf;
endmodule