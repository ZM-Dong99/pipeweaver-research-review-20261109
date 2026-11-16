module pw_miter(in_0, in_1, in_2, mismatch);
input [7:0] in_0;
input [7:0] in_1;
input [2:0] in_2;
wire [7:0] gold_3, cand_3;
output mismatch;
pw_gold gold(.a(in_0), .b(in_1), .Oper(in_2), .sum(gold_3));
pw_cand cand(.a(in_0), .b(in_1), .Oper(in_2), .sum(cand_3));
assign mismatch = (gold_3 != cand_3);
endmodule
