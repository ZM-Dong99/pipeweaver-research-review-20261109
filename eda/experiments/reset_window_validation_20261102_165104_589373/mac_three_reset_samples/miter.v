module pw_miter(in_0,in_1,in_2,in_3,mismatch);
input [0:0] in_0;
input [7:0] in_1;
input [7:0] in_2;
input [0:0] in_3;
wire [15:0] g_4, c_4;
output mismatch;
pw_gold gold(.clk(in_0),.a(in_1),.b(in_2),.reset(in_3),.z(g_4));
pw_cand cand(.clk(in_0),.a(in_1),.b(in_2),.reset(in_3),.z(c_4));
assign mismatch = (g_4 != c_4);
endmodule