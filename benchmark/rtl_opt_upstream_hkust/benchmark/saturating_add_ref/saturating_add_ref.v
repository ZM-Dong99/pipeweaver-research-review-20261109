module saturating_add_ref (
    input clk,
    input signed [7:0] a, b,
    output reg signed [7:0] z
);
    wire signed [8:0] sum = a + b;
    wire overflow  = ~a[7] & ~b[7] &  sum[8];  
    wire underflow =  a[7] &  b[7] & ~sum[8];  
    always @(posedge clk) begin
        z <= overflow  ? 127 :
              underflow ? -128 :
              sum[7:0];
    end
endmodule