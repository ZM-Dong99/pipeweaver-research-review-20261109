module pw_miter(in_0, in_1, in_2, in_3, in_4, mismatch);
input [0:0] in_0;
input [31:0] in_1;
input [31:0] in_2;
input [31:0] in_3;
input [31:0] in_4;
wire [32:0] gold_5, cand_5;
output mismatch;
pw_gold gold(.s(in_0), .A(in_1), .B(in_2), .C(in_3), .D(in_4), .Z(gold_5));
pw_cand cand(.s(in_0), .A(in_1), .B(in_2), .C(in_3), .D(in_4), .Z(cand_5));
assign mismatch = (gold_5 != cand_5);
endmodule
