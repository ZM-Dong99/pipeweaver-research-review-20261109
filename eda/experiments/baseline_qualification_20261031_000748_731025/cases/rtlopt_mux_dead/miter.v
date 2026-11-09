module pw_miter(in_0, in_1, in_2, in_3, mismatch);
input [0:0] in_0;
input [0:0] in_1;
input [7:0] in_2;
input [7:0] in_3;
wire [7:0] gold_4, cand_4;
output mismatch;
pw_gold gold(.x(in_0), .sel(in_1), .a(in_2), .b(in_3), .result(gold_4));
pw_cand cand(.x(in_0), .sel(in_1), .a(in_2), .b(in_3), .result(cand_4));
assign mismatch = (gold_4 != cand_4);
endmodule
