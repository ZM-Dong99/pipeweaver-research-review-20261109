module counter(input clk);
reg [3:0] q = 0;
reg valid = 0;
always @(posedge clk) begin
 q <= q + 4'd1;
 valid <= 1;
 if (valid) assert(q == $past(q) + 4'd2);
end
endmodule
