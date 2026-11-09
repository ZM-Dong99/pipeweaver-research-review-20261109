module saturating_add_mini (
    input clk,
    input signed [7:0] a, b,
    output reg signed [7:0] z
);

    wire signed [8:0] sum = a + b;

    always @(posedge clk) begin
        if (~a[7] & ~b[7] &  sum[8]) begin // Overflow
            z <= 8'd127;
        end else if (a[7] &  b[7] & ~sum[8]) begin // Underflow
            z <= 8'sb10000000; // -128
        end else begin
            z <= sum[7:0];
        end
    end
endmodule