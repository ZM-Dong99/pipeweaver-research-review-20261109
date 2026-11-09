module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire reverse_sub = ~Oper[2] & Oper[1] & ~Oper[0];
    wire subtract = Oper[0];
    wire arithmetic_enable = ~Oper[2] & (~Oper[1] | ~Oper[0]);
    wire [63:0] arithmetic_a = reverse_sub ? b : a;
    wire [63:0] arithmetic_b = reverse_sub ? a : b;
    wire [63:0] arithmetic_result = arithmetic_a + (arithmetic_b ^ {64{subtract}}) + subtract;

    always @(*) begin
        if (arithmetic_enable) begin
            sum = arithmetic_result;
        end else begin
            case (Oper)
                3'b011: sum = a | b;
                3'b100: sum = a & b;
                3'b101: sum = a ^ b;
                3'b110: sum = a ~^ b;
                default: sum = 64'b0;
            endcase
        end
    end
endmodule
