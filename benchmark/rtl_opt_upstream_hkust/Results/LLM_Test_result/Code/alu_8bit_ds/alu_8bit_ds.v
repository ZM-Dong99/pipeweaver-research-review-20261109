module alu_8bit_ds(
input[7:0] a,b,
input[2:0] Oper,
output[7:0] sum
);

wire[8:0] result;
assign result = (Oper == 3'b000) ? {1'b0, a} + {1'b0, b} :
               (Oper == 3'b001) ? {1'b0, a} - {1'b0, b} :
               (Oper == 3'b010) ? {1'b0, b} - {1'b0, a} :
               (Oper == 3'b011) ? {1'b0, a | b} :
               (Oper == 3'b100) ? {1'b0, a & b} :
               (Oper == 3'b101) ? {1'b0, a ^ b} :
               (Oper == 3'b110) ? {1'b0, a ~^ b} :
               9'b0;

assign sum = result[7:0];

endmodule