module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire is_sub = (~Oper[2]) & (~Oper[1]) & Oper[0];
    wire is_reverse = (~Oper[2]) & Oper[1] & (~Oper[0]);
    wire [63:0] arithmetic_a = is_reverse ? b : a;
    wire [63:0] arithmetic_b = is_reverse ? ~a : (is_sub ? ~b : b);
    wire [63:0] arithmetic_result = arithmetic_a + arithmetic_b + {{63{1'b0}}, (is_sub | is_reverse)};

    always @(*) begin
        case (Oper)
            3'b000, 3'b001, 3'b010: sum = arithmetic_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = 64'b0;
        endcase
    end
endmodule
