module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
wire sub;
wire [63:0] arith_x;
wire [63:0] arith_y;
wire [63:0] arith;

assign sub = (Oper[1:0] != 2'b00);
assign arith_x = Oper[1] ? b : a;
assign arith_y = Oper[1] ? a : b;
assign arith = arith_x + (sub ? ~arith_y : arith_y) + {63'b0, sub};

always @(*) begin
    case (Oper)
        3'b000: sum = arith;
        3'b001: sum = arith;
        3'b010: sum = arith;
        3'b011: sum = a | b;
        3'b100: sum = a & b;
        3'b101: sum = a ^ b;
        3'b110: sum = a ~^ b;
        default: sum = 64'b0;
    endcase
end
endmodule
