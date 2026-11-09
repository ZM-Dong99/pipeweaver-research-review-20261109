module pw_miter(in_0, in_1, in_2, mismatch);
input [7:0] in_0;
input [7:0] in_1;
input [0:0] in_2;
wire [7:0] gold_3, cand_3;
wire [0:0] gold_4, cand_4;
output mismatch;
pw_gold gold(.a(in_0), .b(in_1), .cin(in_2), .sum(gold_3), .cout(gold_4));
pw_cand cand(.a(in_0), .b(in_1), .cin(in_2), .sum(cand_3), .cout(cand_4));
assign mismatch = (gold_3 != cand_3) | (gold_4 != cand_4);
endmodule
