module pw_definedness(pw_signal_0, defined);
input [0:0] pw_signal_0;
wire [0:0] pw_signal_1;
output defined;
control  dut(.a(pw_signal_0), .y(pw_signal_1));
assign defined = ((^pw_signal_1) !== 1'bx);
endmodule