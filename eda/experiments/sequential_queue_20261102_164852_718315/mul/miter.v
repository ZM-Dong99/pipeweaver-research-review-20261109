module pw_miter(in_0,in_1,in_2,mismatch);
input [0:0] in_0;
input [7:0] in_1;
input [7:0] in_2;
wire [7:0] g_3, c_3;
output mismatch;
pw_gold gold(.clk(in_0),.a(in_1),.b(in_2),.z(g_3));
pw_cand cand(.clk(in_0),.a(in_1),.b(in_2),.z(c_3));
assign mismatch = (g_3 != c_3);
endmodule