module mul_gpt (
    input clk,
    input signed [7:0] a, b,
    output reg signed [7:0] z
);
    wire signed [15:0] product;
    wire signed [15:0] adjusted;

    assign product = a * b;
    assign adjusted = product + 8'h80; // 1<<7 is the same as 8'h80

    always @(posedge clk) begin
        z <= adjusted[15:8];
    end
endmodule