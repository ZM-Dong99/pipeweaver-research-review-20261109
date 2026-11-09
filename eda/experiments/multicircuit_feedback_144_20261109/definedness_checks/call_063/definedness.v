module pw_definedness(pw_signal_0, defined);
input [7:0] pw_signal_0;
wire [255:0] pw_signal_1;
output defined;
decoder_8bit #(.N(8)) dut(.in(pw_signal_0), .out(pw_signal_1));
assign defined = ((^pw_signal_1) !== 1'bx);
endmodule