module mul_dsr (
    input clk,
    input signed [7:0] a, b,
    output reg signed [7:0] z
);
    wire signed [15:0] product;
    assign product = a * b;

    always @(posedge clk) begin
        z <= product[15:8] + product[7];
    end
endmodule