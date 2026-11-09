module mul_mini (
    input clk,
    input signed [7:0] a, b,
    output reg signed [7:0] z
);

    wire signed [15:0] t;
    assign t = a * b + 128;  // Use integer literal for efficiency

    always @(posedge clk) begin
        z <= t[15:8];
    end

endmodule