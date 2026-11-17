module pw_definedness(pw_signal_0, pw_signal_1, defined);
input [3:0] pw_signal_0;
input [31:0] pw_signal_1;
wire [3:0] pw_signal_2;
wire [31:0] pw_signal_3;
output defined;
pw_crc32_d4  dut(.data_in(pw_signal_0), .state_in(pw_signal_1), .data_out(pw_signal_2), .state_out(pw_signal_3));
assign defined = ((^pw_signal_2) !== 1'bx) & ((^pw_signal_3) !== 1'bx);
endmodule