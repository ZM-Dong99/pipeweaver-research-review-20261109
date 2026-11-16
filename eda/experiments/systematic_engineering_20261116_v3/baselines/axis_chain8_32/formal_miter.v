module pw_miter(in_0,in_1,in_2,in_3,in_5,in_6,in_10,mismatch);
input [0:0] in_0;
input [0:0] in_1;
input [7:0] in_2;
input [0:0] in_3;
wire [0:0] g_4, c_4;
input [0:0] in_5;
input [0:0] in_6;
wire [31:0] g_7, c_7;
wire [3:0] g_8, c_8;
wire [0:0] g_9, c_9;
input [0:0] in_10;
wire [0:0] g_11, c_11;
wire [0:0] g_12, c_12;
output mismatch;
pw_gold gold(.clk(in_0),.rst(in_1),.s_axis_tdata(in_2),.s_axis_tvalid(in_3),.s_axis_tready(g_4),.s_axis_tlast(in_5),.s_axis_tuser(in_6),.m_axis_tdata(g_7),.m_axis_tkeep(g_8),.m_axis_tvalid(g_9),.m_axis_tready(in_10),.m_axis_tlast(g_11),.m_axis_tuser(g_12));
pw_cand cand(.clk(in_0),.rst(in_1),.s_axis_tdata(in_2),.s_axis_tvalid(in_3),.s_axis_tready(c_4),.s_axis_tlast(in_5),.s_axis_tuser(in_6),.m_axis_tdata(c_7),.m_axis_tkeep(c_8),.m_axis_tvalid(c_9),.m_axis_tready(in_10),.m_axis_tlast(c_11),.m_axis_tuser(c_12));
assign mismatch = (g_4 != c_4) | (g_7 != c_7) | (g_8 != c_8) | (g_9 != c_9) | (g_11 != c_11) | (g_12 != c_12);
endmodule