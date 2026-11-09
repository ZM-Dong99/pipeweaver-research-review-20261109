module mul_ds (
    input clk,
    input signed [7:0] a, b,
    output reg signed [7:0] z
);
    reg signed [7:0] a_reg, b_reg;
    wire signed [15:0] t = a_reg * b_reg + 128;

    always @(posedge clk) begin
        a_reg <= a;
        b_reg <= b;
        z <= t[15:8];
    end
endmodule