// Parameterized adaptation of rtl_opt_upstream_hkust/benchmark/alu_64bit.
// The sum output retains the original seven operations and zero default.
module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    always @* begin
        case (Oper)
            3'b000: sum = a + b;
            3'b001: sum = a - b;
            3'b010: sum = b - a;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = {WIDTH{1'b0}};
        endcase
    end
endmodule
