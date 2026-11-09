module saturating_add_dsr (
    input clk,
    input signed [7:0] a, b,
    output reg signed [7:0] z
);

    wire signed [8:0] sum = a + b;
    wire overflow = ~a[7] & ~b[7] & sum[7];
    wire underflow = a[7] & b[7] & ~sum[7];
    
    always @(posedge clk) begin
        z <= overflow  ? 8'sd127 :
             underflow ? 8'sd-128 :
             sum[7:0];
    end
endmodule