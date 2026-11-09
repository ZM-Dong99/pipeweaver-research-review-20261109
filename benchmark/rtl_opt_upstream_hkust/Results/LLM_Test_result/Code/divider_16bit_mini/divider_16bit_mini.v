module divider_16bit_mini (
    input wire [15:0] A,      // 16-bit 被除数
    input wire [7:0] B,       // 8-bit 除数
    output wire [15:0] result, // 16-bit 商
    output wire [15:0] odd     // 16-bit 余数
);

reg [31:0] remainder_quotient; // High 16 bits for remainder, low 16 bits for quotient
reg [15:0] remainder;
reg [15:0] quotient;
integer i;

always @(*) begin
    remainder_quotient = {16'b0, A}; // Initialize remainder with 0, quotient with A (initial guess)

    // Signed division using restoring method adapted for unsigned with sign tracking
    // This loop performs 16 steps for the 16-bit quotient
    for (i = 0; i < 16; i = i + 1) begin
        remainder_quotient = remainder_quotient << 1; // Left shift remainder and room for quotient bit
        
        // Tentatively subtract B from the current remainder
        remainder_quotient[31:16] = remainder_quotient[31:16] - {8'b0, B};
        
        // Check the sign of the result of subtraction
        if (remainder_quotient[31] == 1'b0) begin // Result is non-negative (successful subtraction)
            // Set the current quotient bit to 1
            remainder_quotient[0] = 1'b1;
        end 
        else begin // Result is negative (subtraction failed)
            // Set the current quotient bit to 0
            remainder_quotient[0] = 1'b0;
            // Restore the remainder by adding B back
            remainder_quotient[31:16] = remainder_quotient[31:16] + {8'b0, B};
        end
    end
    
    remainder = remainder_quotient[31:16];
    quotient = remainder_quotient[15:0];

    // According to standard unsigned division, the operations should yield a non-negative remainder.
    // The loop structure implements the unsigned division algorithm directly.
    // No final adjustment is needed for unsigned division using this method.
end

assign result = quotient;  // quotient
assign odd = remainder;    // remainder

endmodule