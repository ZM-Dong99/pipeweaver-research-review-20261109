module comparator_ds #(
    parameter N = 8
) (
    input [2:0] SEL,
    input [N-1:0] value1,
    input [N-1:0] value2,
    output reg OUT
);

wire [1:0] cmp_results;
assign cmp_results = {(value1 > value2), (value1 == value2)};

always @(*) begin
    case (SEL)
        3'b000: OUT = 1'b0;
        3'b001: OUT = 1'b1;
        3'b010: OUT = cmp_results[0];
        3'b011: OUT = ~cmp_results[0];
        3'b100: OUT = |cmp_results;
        3'b101: OUT = ~cmp_results[1];
        3'b110: OUT = ~(&cmp_results);
        3'b111: OUT = cmp_results[1];
        default: OUT = 1'b0;
    endcase
end

endmodule