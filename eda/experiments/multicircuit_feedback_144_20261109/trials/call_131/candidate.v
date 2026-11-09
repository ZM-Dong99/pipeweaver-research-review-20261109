module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
wire arithmetic_mode;
wire subtract_mode;
wire [63:0] arithmetic_result;
wire [63:0] logic_result;
wire [63:0] arithmetic_x;
wire [63:0] arithmetic_y;

assign arithmetic_mode = ~Oper[2] & ~Oper[1];
assign subtract_mode = Oper[0] | Oper[1];
assign arithmetic_x = Oper[1] ? b : a;
assign arithmetic_y = Oper[1] ? a : b;
assign arithmetic_result = arithmetic_x + (arithmetic_y ^ {64{subtract_mode}}) + subtract_mode;
assign logic_result = (Oper == 3'b011) ? (a | b) :
                      (Oper == 3'b100) ? (a & b) :
                      (Oper == 3'b101) ? (a ^ b) :
                      (Oper == 3'b110) ? (a ~^ b) : 64'b0;

always @(*) begin
    if (arithmetic_mode)
        sum = arithmetic_result;
    else if (Oper == 3'b111)
        sum = 64'b0;
    else
        sum = logic_result;
end
endmodule
