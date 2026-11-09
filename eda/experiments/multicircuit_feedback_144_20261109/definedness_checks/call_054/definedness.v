module pw_definedness(pw_signal_0, pw_signal_1, defined);
input [7:0] pw_signal_0;
input [7:0] pw_signal_1;
wire [15:0] pw_signal_2;
output defined;
mul_subexpression  dut(.multiplicand(pw_signal_0), .multiplier(pw_signal_1), .product(pw_signal_2));
assign defined = ((^pw_signal_2) !== 1'bx);
endmodule