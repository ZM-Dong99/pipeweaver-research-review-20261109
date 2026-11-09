module sub_8bit_gpt (
    input [7:0] a,
    input [7:0] b,
    output [7:0] diff,
    output overflow
);
    reg [7:0] difference;
    reg ovf;

    always @(*) begin
        difference = a - b; // Use direct subtraction for efficiency
        ovf = (a[7] ^ b[7]) && (difference[7] != a[7]); // Overflow detection
    end
    
    assign diff = difference;
    assign overflow = ovf;
endmodule