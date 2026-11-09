module pw_miter(in_0, in_1, mismatch);
input [15:0] in_0;
input [15:0] in_1;
wire [0:0] gold_2, cand_2;
wire [0:0] gold_3, cand_3;
wire [0:0] gold_4, cand_4;
output mismatch;
pw_gold gold(.A(in_0), .B(in_1), .gt(gold_2), .eq(gold_3), .lt(gold_4));
pw_cand cand(.A(in_0), .B(in_1), .gt(cand_2), .eq(cand_3), .lt(cand_4));
assign mismatch = (gold_2 != cand_2) | (gold_3 != cand_3) | (gold_4 != cand_4);
endmodule
