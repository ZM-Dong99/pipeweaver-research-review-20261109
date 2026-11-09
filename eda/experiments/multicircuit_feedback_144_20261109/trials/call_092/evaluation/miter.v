module pw_miter(in_0, in_1, mismatch);
input [7:0] in_0;
input [7:0] in_1;
wire [15:0] gold_2, cand_2;
output mismatch;
pw_gold gold(.multiplicand(in_0), .multiplier(in_1), .product(gold_2));
pw_cand cand(.multiplicand(in_0), .multiplier(in_1), .product(cand_2));
assign mismatch = (gold_2 != cand_2);
endmodule
