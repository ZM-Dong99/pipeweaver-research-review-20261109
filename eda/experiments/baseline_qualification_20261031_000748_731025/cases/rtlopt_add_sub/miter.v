module pw_miter(in_0, in_1, in_2, mismatch);
input [15:0] in_0;
input [15:0] in_1;
input [0:0] in_2;
wire [15:0] gold_3, cand_3;
output mismatch;
pw_gold gold(.a(in_0), .b(in_1), .control(in_2), .result(gold_3));
pw_cand cand(.a(in_0), .b(in_1), .control(in_2), .result(cand_3));
assign mismatch = (gold_3 != cand_3);
endmodule
