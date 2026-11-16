module pw_miter(in_0,in_1,in_2,in_3,mismatch);
input [0:0] in_0;
input [0:0] in_1;
input [31:0] in_2;
input [31:0] in_3;
wire [31:0] g_4, c_4;
wire [0:0] g_5, c_5;
wire [4:0] g_6, c_6;
wire [4:0] g_7, c_7;
wire [31:0] g_8, c_8;
wire [0:0] g_9, c_9;
wire [31:0] g_10, c_10;
output mismatch;
pw_gold gold(.clk(in_0),.rst(in_1),.request(in_2),.acknowledge(in_3),.grant(g_4),.grant_valid(g_5),.grant_encoded(g_6),.grant_encoded_reg(g_7),.grant_reg(g_8),.grant_valid_reg(g_9),.mask_reg(g_10));
pw_cand cand(.clk(in_0),.rst(in_1),.request(in_2),.acknowledge(in_3),.grant(c_4),.grant_valid(c_5),.grant_encoded(c_6),.grant_encoded_reg(c_7),.grant_reg(c_8),.grant_valid_reg(c_9),.mask_reg(c_10));
assign mismatch = (g_4 != c_4) | (g_5 != c_5) | (g_6 != c_6) | (g_7 != c_7) | (g_8 != c_8) | (g_9 != c_9) | (g_10 != c_10);
endmodule