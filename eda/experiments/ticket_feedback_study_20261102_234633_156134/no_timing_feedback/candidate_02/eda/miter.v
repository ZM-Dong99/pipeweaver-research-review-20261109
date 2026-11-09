module pw_miter(in_0,in_1,in_2,in_3,mismatch);
input [0:0] in_0;
input [0:0] in_1;
input [0:0] in_2;
input [0:0] in_3;
wire [0:0] g_4, c_4;
wire [0:0] g_5, c_5;
wire [0:0] g_6, c_6;
wire [0:0] g_7, c_7;
output mismatch;
pw_gold gold(.clk(in_0),.clear(in_1),.ten(in_2),.twenty(in_3),.ready(g_4),.dispense(g_5),.return_sig(g_6),.bill(g_7));
pw_cand cand(.clk(in_0),.clear(in_1),.ten(in_2),.twenty(in_3),.ready(c_4),.dispense(c_5),.return_sig(c_6),.bill(c_7));
assign mismatch = (g_4 != c_4) | (g_5 != c_5) | (g_6 != c_6) | (g_7 != c_7);
endmodule