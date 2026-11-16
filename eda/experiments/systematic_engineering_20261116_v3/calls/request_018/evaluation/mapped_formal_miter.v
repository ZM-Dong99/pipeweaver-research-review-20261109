module pw_miter(in_0,in_1,in_2,in_3,mismatch);
input [0:0] in_0;
input [0:0] in_1;
input [0:0] in_2;
input [7:0] in_3;
wire [7:0] g_4, c_4;
wire [0:0] g_5, c_5;
wire [8:0] g_6, c_6;
output mismatch;
pw_gold gold(.clk(in_0),.rst(in_1),.start(in_2),.data_in(in_3),.data_out(g_4),.done(g_5),.state(g_6));
pw_cand cand(.clk(in_0),.rst(in_1),.start(in_2),.data_in(in_3),.data_out(c_4),.done(c_5),.state(c_6));
assign mismatch = (g_4 != c_4) | (g_5 != c_5) | (g_6 != c_6);
endmodule