module pw_miter(in_0, in_1, in_2, in_3, mismatch);
input [7:0] in_0;
input [7:0] in_1;
input [7:0] in_2;
input [7:0] in_3;
wire [7:0] gold_4, cand_4;
wire [7:0] gold_5, cand_5;
wire [7:0] gold_6, cand_6;
wire [7:0] gold_7, cand_7;
wire [7:0] gold_8, cand_8;
wire [7:0] gold_9, cand_9;
output mismatch;
pw_gold gold(.a(in_0), .b(in_1), .c(in_2), .d(in_3), .s1(gold_4), .s2(gold_5), .s3(gold_6), .s4(gold_7), .s5(gold_8), .s6(gold_9));
pw_cand cand(.a(in_0), .b(in_1), .c(in_2), .d(in_3), .s1(cand_4), .s2(cand_5), .s3(cand_6), .s4(cand_7), .s5(cand_8), .s6(cand_9));
assign mismatch = (gold_4 != cand_4) | (gold_5 != cand_5) | (gold_6 != cand_6) | (gold_7 != cand_7) | (gold_8 != cand_8) | (gold_9 != cand_9);
endmodule
