module pw_miter(in_0, in_1, mismatch);
input [3:0] in_0;
input [3:0] in_1;
wire [3:0] gold_2, cand_2;
wire [0:0] gold_3, cand_3;
output mismatch;
pw_gold gold(.a(in_0), .b(in_1), .diff(gold_2), .overflow(gold_3));
pw_cand cand(.a(in_0), .b(in_1), .diff(cand_2), .overflow(cand_3));
assign mismatch = (gold_2 != cand_2) | (gold_3 != cand_3);
endmodule
