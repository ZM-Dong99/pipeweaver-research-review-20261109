module sub_4bit_gpt (
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff,
    output overflow
);
    reg [3:0] difference;
    reg ovf;
    reg borrow;
    
    always @(*) begin
        borrow = 0;
        difference = 0; // Initialize difference to ensure proper synthesis behavior
        for (integer i = 0; i < 4; i = i + 1) begin
            {borrow, difference[i]} = a[i] - b[i] - borrow; // Use simple subtraction to compute diff and borrow
        end
        
        // Overflow detection: highest bit borrow and sign bit change inconsistency
        ovf = (a[3] ^ b[3]) && (difference[3] != a[3]);
    end
    
    assign diff = difference;
    assign overflow = ovf;
endmodule