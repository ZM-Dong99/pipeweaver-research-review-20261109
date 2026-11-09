module pw_miter(in_0, in_1, in_2, mismatch);
input [79:0] in_0;
input [3:0] in_1;
input [63:0] in_2;
wire [7:0] gold_3, cand_3;
wire [0:0] gold_4, cand_4;
wire [5:0] gold_5, cand_5;
wire [63:0] gold_6, cand_6;
output mismatch;
pw_gold gold(.mux_data(in_0), .mux_sel(in_1), .requests(in_2), .selected_data(gold_3), .request_valid(gold_4), .request_index(gold_5), .request_onehot(gold_6));
pw_cand cand(.mux_data(in_0), .mux_sel(in_1), .requests(in_2), .selected_data(cand_3), .request_valid(cand_4), .request_index(cand_5), .request_onehot(cand_6));
assign mismatch = (gold_3 != cand_3) | (gold_4 != cand_4) | (gold_5 != cand_5) | (gold_6 != cand_6);
endmodule
