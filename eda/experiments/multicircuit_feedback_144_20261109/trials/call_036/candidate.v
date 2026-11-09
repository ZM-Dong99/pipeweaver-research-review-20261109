module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire reverse_sub;
    wire subtract;
    wire [63:0] add_x;
    wire [63:0] add_y;
    wire [63:0] add_result;

    assign reverse_sub = ~Oper[2] & Oper[1] & ~Oper[0];
    assign subtract = ~Oper[2] & (Oper[1] | Oper[0]);
    assign add_x = reverse_sub ? b : a;
    assign add_y = reverse_sub ? a : b;
    assign add_result = add_x + (add_y ^ {64{subtract}}) + subtract;

    always @(*) begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = add_result;
            3'b010: sum = add_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = 64'b0;
        endcase
    end
endmodule
