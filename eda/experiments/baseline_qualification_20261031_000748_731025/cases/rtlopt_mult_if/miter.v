module pw_miter(in_0, in_1, in_2, mismatch);
input [7:0] in_0;
input [4:0] in_1;
input [0:0] in_2;
wire [0:0] gold_3, cand_3;
output mismatch;
pw_gold gold(.A(in_0), .C(in_1), .CTRL_is_late_arriving(in_2), .Z(gold_3));
pw_cand cand(.A(in_0), .C(in_1), .CTRL_is_late_arriving(in_2), .Z(cand_3));
assign mismatch = (gold_3 != cand_3);
endmodule
