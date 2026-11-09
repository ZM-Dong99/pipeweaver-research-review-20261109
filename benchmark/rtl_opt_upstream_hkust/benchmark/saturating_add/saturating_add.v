module saturating_add (
    input clk,
    input signed [7:0] a, b,
    output reg signed [7:0] z
);

    wire signed [8:0] sum = a + b;
    reg overflow, underflow;
    
    always @(posedge clk) begin
        overflow  <= ~a[7] & ~b[7] &  sum[8];  
        underflow <=  a[7] &  b[7] & ~sum[8];  
        z <= overflow  ? 127 :
              underflow ? -128 :
              sum[7:0];
    end
endmodule