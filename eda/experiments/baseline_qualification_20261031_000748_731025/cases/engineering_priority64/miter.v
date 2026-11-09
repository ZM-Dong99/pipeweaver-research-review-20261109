module pw_miter(in_0, mismatch);
input [63:0] in_0;
wire [0:0] gold_1, cand_1;
wire [5:0] gold_2, cand_2;
wire [63:0] gold_3, cand_3;
output mismatch;
pw_gold gold(.input_unencoded(in_0), .output_valid(gold_1), .output_encoded(gold_2), .output_unencoded(gold_3));
pw_cand cand(.input_unencoded(in_0), .output_valid(cand_1), .output_encoded(cand_2), .output_unencoded(cand_3));
assign mismatch = (gold_1 != cand_1) | (gold_2 != cand_2) | (gold_3 != cand_3);
endmodule
