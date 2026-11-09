module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire arithmetic;
    wire subtract;
    wire reverse_subtract;
    wire [63:0] adder_a;
    wire [63:0] adder_b;
    wire [64:0] arithmetic_ext;
    reg [63:0] logic_result;

    assign arithmetic = ~Oper[2] & ~(Oper[1] & Oper[0]);
    assign subtract = Oper[1] | Oper[0];
    assign reverse_subtract = Oper[1] & ~Oper[0];
    assign adder_a = reverse_subtract ? b : a;
    assign adder_b = subtract ? (reverse_subtract ? ~a : ~b) : b;
    assign arithmetic_ext = {1'b0, adder_a} + {1'b0, adder_b} + {{64{1'b0}}, subtract};

    always @(*) begin
        case (Oper)
            3'b011: logic_result = a | b;
            3'b100: logic_result = a & b;
            3'b101: logic_result = a ^ b;
            3'b110: logic_result = a ~^ b;
            default: logic_result = 64'b0;
        endcase
    end

    always @(*) begin
        if (arithmetic)
            sum = arithmetic_ext[63:0];
        else
            sum = logic_result;
    end
endmodule
