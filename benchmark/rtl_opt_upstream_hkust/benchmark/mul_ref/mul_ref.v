module mul_ref (
    input clk,
    input signed [7:0] a, b,
    output reg signed [7:0] z
);
    wire signed [15:0] t;
    assign t = a * b;
    wire signed [7:0] z_next = t[15:8] + t[7];

    always @(posedge clk) begin
        z <= z_next;
    end
endmodule