module saturating_add_gpt (
    input clk,
    input signed [7:0] a, b,
    output reg signed [7:0] z
);

    reg signed [8:0] sum;
    
    always @(posedge clk) begin
        sum <= a + b; 
        z <= (sum > 8'sd127) ? 8'sd127 :
             (sum < 8'sd-128) ? 8'sd-128 :
             sum[7:0];
    end
endmodule