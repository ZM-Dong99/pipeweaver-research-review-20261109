module pw_miter(in_0, in_1, mismatch);
input [7:0] in_0;
input [3:0] in_1;
wire [7:0] gold_2, cand_2;
wire [7:0] gold_3, cand_3;
output mismatch;
pw_gold gold(.A(in_0), .B(in_1), .result(gold_2), .odd(gold_3));
pw_cand cand(.A(in_0), .B(in_1), .result(cand_2), .odd(cand_3));
assign mismatch = (gold_2 != cand_2) | (gold_3 != cand_3);
endmodule
