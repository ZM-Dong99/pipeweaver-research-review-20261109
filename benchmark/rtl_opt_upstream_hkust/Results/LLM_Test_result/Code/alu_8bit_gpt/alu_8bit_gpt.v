module alu_8bit_gpt(
input[7:0] a,b,
input[2:0]Oper,

output reg[7:0] sum
    );
reg c_out;
always@(*)
begin
	case(Oper)
	3'b000:  {c_out,sum} = a + b;            // Addition
	3'b001:  {c_out,sum} = a - b;            // Subtraction
	3'b010:  {c_out,sum} = b - a;            // Reverse Subtraction
	3'b011:  {c_out,sum} = a | b;            // Bitwise OR
	3'b100:  {c_out,sum} = a & b;            // Bitwise AND
	3'b101:  {c_out,sum} = a ^ b;            // Bitwise XOR
	3'b110:  {c_out,sum} = a ~^ b;           // Bitwise XNOR
	default: {c_out,sum} = 9'b0;              // Default case
	endcase
end
endmodule