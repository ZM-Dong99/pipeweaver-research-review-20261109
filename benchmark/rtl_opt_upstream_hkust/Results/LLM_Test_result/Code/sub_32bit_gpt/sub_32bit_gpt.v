module sub_32bit_gpt (
    input [31:0] a,
    input [31:0] b,
    output [31:0] diff,
    output overflow
);
    reg [31:0] difference;
    reg ovf;
    
    always @(*) begin
        {ovf, difference} = a - b; // Efficient subtraction operation
    end
    
    // Overflow detection: highest bit borrow and sign bit change inconsistency
    assign overflow = (a[31] ^ b[31]) & (difference[31] != a[31]);
    assign diff = difference;
endmodule