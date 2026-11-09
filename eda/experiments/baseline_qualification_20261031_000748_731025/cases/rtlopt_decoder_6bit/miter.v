module pw_miter(in_0, mismatch);
input [5:0] in_0;
wire [63:0] gold_1, cand_1;
output mismatch;
pw_gold gold(.in(in_0), .out(gold_1));
pw_cand cand(.in(in_0), .out(cand_1));
assign mismatch = (gold_1 != cand_1);
endmodule
