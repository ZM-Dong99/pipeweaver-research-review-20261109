module alu_64bit_mini(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
always @(*) begin
    case(Oper)
        3'b000:  sum = a + b; // Sum, carry-out is implicitly handled by the sum size
        3'b001:  sum = a - b; // Subtract (a-b)
        3'b010:  sum = b - a; // Subtract (b-a)
        3'b011:  sum = a | b; // OR
        3'b100:  sum = a & b; // AND
        3'b101:  sum = a ^ b; // XOR
        3'b110:  sum = a ~^ b; // XNOR
        default: sum = 64'b0; // Default
    endcase
end
endmodule