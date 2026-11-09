module comparator_gpt #(
    parameter N = 8              // Define parameter first
) (
    input [2:0] SEL,          // 3-bit selection signal
    input [N-1:0] value1,     // First comparison value
    input [N-1:0] value2,     // Second comparison value
    output reg OUT            // Comparison result output
);

// Pre-compute comparison results
wire cmp_equal = (value1 == value2);
wire cmp_greater = (value1 > value2);
wire cmp_less = (value1 < value2);

// Optimize the case statement
always @(*) begin
    case (SEL)
        3'b000: OUT = 1'b0;               // Constant 0
        3'b001: OUT = 1'b1;               // Constant 1
        3'b010: OUT = cmp_equal;         // ==
        3'b011: OUT = ~cmp_equal;        // !=
        3'b100: OUT = cmp_equal | cmp_greater;  // >=
        3'b101: OUT = ~cmp_greater;      // <=
        3'b110: OUT = cmp_less;          // <
        3'b111: OUT = cmp_greater;       // >
        default: OUT = 1'b0;             // Default case
    endcase
end

endmodule