module pw_miter(in_0,in_1,in_2,mismatch);
input [0:0] in_0;
input [0:0] in_1;
input [0:0] in_2;
wire [3:0] g_3, c_3;
output mismatch;
pw_gold gold(.clk(in_0),.rst(in_1),.en(in_2),.q(g_3));
pw_cand cand(.clk(in_0),.rst(in_1),.en(in_2),.q(c_3));
assign mismatch = (g_3 != c_3);
endmodule