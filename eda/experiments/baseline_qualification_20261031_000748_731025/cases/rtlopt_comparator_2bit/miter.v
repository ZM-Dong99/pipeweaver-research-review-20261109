module pw_miter(in_0, in_1, mismatch);
input [1:0] in_0;
input [1:0] in_1;
wire [0:0] gold_2, cand_2;
wire [0:0] gold_3, cand_3;
wire [0:0] gold_4, cand_4;
output mismatch;
pw_gold gold(.A(in_0), .B(in_1), .eq(gold_2), .gt(gold_3), .lt(gold_4));
pw_cand cand(.A(in_0), .B(in_1), .eq(cand_2), .gt(cand_3), .lt(cand_4));
assign mismatch = (gold_2 != cand_2) | (gold_3 != cand_3) | (gold_4 != cand_4);
endmodule
