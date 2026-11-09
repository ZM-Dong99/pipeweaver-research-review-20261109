module pw_miter(in_0, in_1, in_2, mismatch);
input [2:0] in_0;
input [23:0] in_1;
input [23:0] in_2;
wire [0:0] gold_3, cand_3;
output mismatch;
pw_gold gold(.SEL(in_0), .value1(in_1), .value2(in_2), .OUT(gold_3));
pw_cand cand(.SEL(in_0), .value1(in_1), .value2(in_2), .OUT(cand_3));
assign mismatch = (gold_3 != cand_3);
endmodule
