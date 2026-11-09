module adder_select_dsr(
    input wire s,
    input wire [31:0] A, B, C, D,
    output reg [32:0] Z
);

wire [31:0] mux_A = s ? A : C;
wire [31:0] mux_B = s ? B : D;

always @(*) begin
    Z <= mux_A + mux_B;
end

endmodule