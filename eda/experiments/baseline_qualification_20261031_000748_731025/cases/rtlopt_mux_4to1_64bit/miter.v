module pw_miter(in_0, in_1, in_2, in_3, in_4, mismatch);
input [63:0] in_0;
input [63:0] in_1;
input [63:0] in_2;
input [63:0] in_3;
input [1:0] in_4;
wire [63:0] gold_5, cand_5;
output mismatch;
pw_gold gold(.data0(in_0), .data1(in_1), .data2(in_2), .data3(in_3), .sel(in_4), .out(gold_5));
pw_cand cand(.data0(in_0), .data1(in_1), .data2(in_2), .data3(in_3), .sel(in_4), .out(cand_5));
assign mismatch = (gold_5 != cand_5);
endmodule
