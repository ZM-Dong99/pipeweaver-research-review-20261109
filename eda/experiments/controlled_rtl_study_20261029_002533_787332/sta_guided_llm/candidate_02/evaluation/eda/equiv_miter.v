module equiv_miter(input clk, input rst_n, input [31:0] a,b,c);
wire [31:0] gold_y, cand_y;
timing_adder_gold gold(clk,rst_n,a,b,c,gold_y);
timing_adder_cand cand(clk,rst_n,a,b,c,cand_y);
reg past_valid = 1'b0;
always @(posedge clk) begin
  past_valid <= 1'b1;
  if (!past_valid) assume(!rst_n);
  if (past_valid) assert(gold_y == cand_y);
end
endmodule
