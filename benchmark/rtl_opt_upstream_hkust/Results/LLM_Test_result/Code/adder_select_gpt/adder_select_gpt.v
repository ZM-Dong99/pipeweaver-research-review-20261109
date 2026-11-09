module adder_select_gpt(
    input wire s,
    input wire [31:0] A, B, C, D,
    output reg [32:0] Z
);

always @* begin
    if (s)
        Z = A + B;
    else
        Z = C + D;
end

endmodule