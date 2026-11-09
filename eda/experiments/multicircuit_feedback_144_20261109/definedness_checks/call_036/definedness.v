module pw_definedness(pw_signal_0, pw_signal_1, pw_signal_2, defined);
input [63:0] pw_signal_0;
input [63:0] pw_signal_1;
input [2:0] pw_signal_2;
wire [63:0] pw_signal_3;
output defined;
alu_64bit  dut(.a(pw_signal_0), .b(pw_signal_1), .Oper(pw_signal_2), .sum(pw_signal_3));
assign defined = ((^pw_signal_3) !== 1'bx);
endmodule