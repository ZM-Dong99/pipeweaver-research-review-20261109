module alu_8bit_ref(
    input [7:0] a, b,
    input [2:0] Oper,

    output reg [7:0] sum
);
reg c_out;
reg [7:0] op_a, op_b;
reg carry;
wire [8:0] adder_result = op_a + op_b + carry;

always @(*) begin

    case (Oper)
        3'b000: begin // a + b
            op_a = a;
            op_b = b;
            carry = 1'b0;
        end
        3'b001: begin // a - b
            op_a = a;
            op_b = ~b;
            carry = 1'b1;
        end
        3'b010: begin // b - a
            op_a = b;
            op_b = ~a;
            carry = 1'b1;
        end
        default: begin 
            op_a = 8'b0;
            op_b = 8'b0;
            carry = 1'b0;
        end
    endcase

    case (Oper)
        3'b000, 3'b001, 3'b010: begin
            {c_out, sum} = adder_result;
        end
        3'b011: {sum, c_out} = {a | b, 1'b0};  
        3'b100: {sum, c_out} = {a & b, 1'b0};  
        3'b101: {sum, c_out} = {a ^ b, 1'b0};  
        3'b110: {sum, c_out} = {a ~^ b, 1'b0}; 
        default: {c_out, sum} = 9'b0;          
    endcase
end

endmodule