module pw_definedness(pw_signal_0, defined);
input [255:0] pw_signal_0;
wire [0:0] pw_signal_1;
wire [7:0] pw_signal_2;
wire [255:0] pw_signal_3;
output defined;
priority_encoder #(.WIDTH(256), .LSB_HIGH_PRIORITY(0)) dut(.input_unencoded(pw_signal_0), .output_valid(pw_signal_1), .output_encoded(pw_signal_2), .output_unencoded(pw_signal_3));
assign defined = ((^pw_signal_1) !== 1'bx) & ((^pw_signal_2) !== 1'bx) & ((^pw_signal_3) !== 1'bx);
endmodule