module pw_definedness(pw_signal_0, pw_signal_1, defined);
input [15:0] pw_signal_0;
input [15:0] pw_signal_1;
wire [0:0] pw_signal_2;
wire [0:0] pw_signal_3;
wire [0:0] pw_signal_4;
output defined;
comparator_16bit  dut(.A(pw_signal_0), .B(pw_signal_1), .gt(pw_signal_2), .eq(pw_signal_3), .lt(pw_signal_4));
assign defined = ((^pw_signal_2) !== 1'bx) & ((^pw_signal_3) !== 1'bx) & ((^pw_signal_4) !== 1'bx);
endmodule