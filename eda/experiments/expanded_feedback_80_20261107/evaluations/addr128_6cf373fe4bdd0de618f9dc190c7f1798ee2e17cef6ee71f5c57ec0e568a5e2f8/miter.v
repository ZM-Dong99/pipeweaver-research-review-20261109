module pw_miter(in_0, in_1, in_2, in_3, in_4, mismatch);
input [7:0] in_0;
input [7:0] in_1;
input [7:0] in_2;
input [7:0] in_3;
input [0:0] in_4;
wire [15:0] gold_5, cand_5;
output mismatch;
pw_gold gold(.address(in_0), .ptr1(in_1), .ptr2(in_2), .b(in_3), .control(in_4), .count(gold_5));
pw_cand cand(.address(in_0), .ptr1(in_1), .ptr2(in_2), .b(in_3), .control(in_4), .count(cand_5));
assign mismatch = (gold_5 != cand_5);
endmodule
