module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
wire [63:0] add_a = Oper[1] ? ~a : a;
wire [63:0] add_b = Oper[0] ? ~b : b;
wire add_cin = Oper[1] | Oper[0];
wire [63:0] arithmetic_sum = add_a + add_b + add_cin;

always @(*) begin
    case (Oper)
        3'b000, 3'b001, 3'b010: sum = arithmetic_sum;
        3'b011: sum = a | b;
        3'b100: sum = a & b;
        3'b101: sum = a ^ b;
        3'b110: sum = a ~^ b;
        default: sum = 64'b0;
    endcase
end
endmodule
