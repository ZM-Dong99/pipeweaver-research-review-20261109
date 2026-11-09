module alu_8bit_mini(
input[7:0] a,b,
input[2:0]Oper,

output reg[7:0] sum
    );

always@(*)
begin
	case(Oper)
	3'b000:  sum = a + b;
	3'b001:  sum = a - b;
	3'b010:  sum = b - a;
	3'b011:  sum = a | b;
	3'b100:  sum = a & b;
	3'b101:  sum = a ^ b;
	3'b110:  sum = a ~^ b;
	default: sum = 8'b0;
	endcase
end
endmodule