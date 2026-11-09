module pw_miter(in_0,in_1,in_2,in_3,mismatch);
input [0:0] in_0;
input [0:0] in_1;
input [3:0] in_2;
input [3:0] in_3;
wire [3:0] g_4, c_4;
wire [0:0] g_5, c_5;
wire [1:0] g_6, c_6;
output mismatch;
pw_gold gold(.clk(in_0),.rst(in_1),.request(in_2),.acknowledge(in_3),.grant(g_4),.grant_valid(g_5),.grant_encoded(g_6));
pw_cand cand(.clk(in_0),.rst(in_1),.request(in_2),.acknowledge(in_3),.grant(c_4),.grant_valid(c_5),.grant_encoded(c_6));
assign mismatch = (g_4 != c_4) | (g_5 != c_5) | (g_6 != c_6);
endmodule