module alu_64bit_ref(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
reg c_out;
reg [63:0] op_a, op_b;
reg carry;
wire [64:0] adder_result = op_a + op_b + carry;

always @(*) begin
    case (Oper)
        3'b000: {op_a, op_b, carry} = {a, b, 1'b0};
        3'b001: {op_a, op_b, carry} = {a, ~b, 1'b1};
        3'b010: {op_a, op_b, carry} = {b, ~a, 1'b1};
        default: {op_a, op_b, carry} = {64'b0, 64'b0, 1'b0};
    endcase

    case (Oper)
        3'b000, 3'b001, 3'b010: {c_out, sum} = adder_result;
        3'b011: {sum, c_out} = {a | b, 1'b0};
        3'b100: {sum, c_out} = {a & b, 1'b0};
        3'b101: {sum, c_out} = {a ^ b, 1'b0};
        3'b110: {sum, c_out} = {a ~^ b, 1'b0};
        default: {c_out, sum} = 65'b0;
    endcase
end
endmodule