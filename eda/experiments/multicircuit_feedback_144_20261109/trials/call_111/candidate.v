module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
wire is_sub;
wire [63:0] arith_a;
wire [63:0] arith_b;
wire [63:0] arith_result;
wire [63:0] logic_result;

assign is_sub = (Oper == 3'b001) || (Oper == 3'b010);
assign arith_a = (Oper == 3'b010) ? b : a;
assign arith_b = (Oper == 3'b000) ? b :
                 (Oper == 3'b001) ? ~b : ~a;
assign arith_result = arith_a + arith_b + is_sub;

assign logic_result = (Oper == 3'b011) ? (a | b) :
                      (Oper == 3'b100) ? (a & b) :
                      (Oper == 3'b101) ? (a ^ b) :
                      (Oper == 3'b110) ? (a ~^ b) :
                      64'b0;

always @(*) begin
    case (Oper)
        3'b000, 3'b001, 3'b010: sum = arith_result;
        3'b011, 3'b100, 3'b101, 3'b110: sum = logic_result;
        default: sum = 64'b0;
    endcase
end
endmodule
