module pw_miter(in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, mismatch);
input [7:0] in_0;
input [7:0] in_1;
input [7:0] in_2;
input [7:0] in_3;
input [7:0] in_4;
input [7:0] in_5;
input [7:0] in_6;
input [7:0] in_7;
input [7:0] in_8;
input [7:0] in_9;
input [3:0] in_10;
wire [7:0] gold_11, cand_11;
output mismatch;
pw_gold gold(.block_a(in_0), .block_b(in_1), .block_c(in_2), .block_d(in_3), .block_e(in_4), .block_f(in_5), .block_g(in_6), .block_h(in_7), .block_i(in_8), .block_j(in_9), .sel(in_10), .block_out(gold_11));
pw_cand cand(.block_a(in_0), .block_b(in_1), .block_c(in_2), .block_d(in_3), .block_e(in_4), .block_f(in_5), .block_g(in_6), .block_h(in_7), .block_i(in_8), .block_j(in_9), .sel(in_10), .block_out(cand_11));
assign mismatch = (gold_11 != cand_11);
endmodule
