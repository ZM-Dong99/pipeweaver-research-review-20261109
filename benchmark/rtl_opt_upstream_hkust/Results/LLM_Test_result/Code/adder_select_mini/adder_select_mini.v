module adder_select_mini(
    input wire s,
    input wire [31:0] A, B, C, D,
    output reg [32:0] Z
);

wire [32:0] sum1, sum2;

assign sum1 = A + B;
assign sum2 = C + D;

always @(*) begin
    if (s)
        Z = sum1;
    else
        Z = sum2;
end

endmodule