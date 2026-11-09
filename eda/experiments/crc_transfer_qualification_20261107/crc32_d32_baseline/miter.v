module pw_miter(in_0, in_1, mismatch);
input [31:0] in_0;
input [31:0] in_1;
wire [31:0] gold_2, cand_2;
wire [31:0] gold_3, cand_3;
output mismatch;
pw_gold gold(.data_in(in_0), .state_in(in_1), .data_out(gold_2), .state_out(gold_3));
pw_cand cand(.data_in(in_0), .state_in(in_1), .data_out(cand_2), .state_out(cand_3));
assign mismatch = (gold_2 != cand_2) | (gold_3 != cand_3);
endmodule
