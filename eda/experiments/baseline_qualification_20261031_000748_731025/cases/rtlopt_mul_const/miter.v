module pw_miter(in_0, in_1, in_2, mismatch);
input [7:0] in_0;
input [7:0] in_1;
input [7:0] in_2;
wire [7:0] gold_3, cand_3;
wire [7:0] gold_4, cand_4;
wire [7:0] gold_5, cand_5;
output mismatch;
pw_gold gold(.a(in_0), .b(in_1), .c(in_2), .s1(gold_3), .s2(gold_4), .s3(gold_5));
pw_cand cand(.a(in_0), .b(in_1), .c(in_2), .s1(cand_3), .s2(cand_4), .s3(cand_5));
assign mismatch = (gold_3 != cand_3) | (gold_4 != cand_4) | (gold_5 != cand_5);
endmodule
