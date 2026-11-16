module pw_definedness(signal_0, signal_1, signal_2, defined);
input [0:0] signal_0;
input [0:0] signal_1;
input [0:0] signal_2;
wire [0:0] signal_3;
wire [0:0] signal_4;
output defined;
control dut(.\clk (signal_0), .\rst (signal_1), .\a (signal_2), .\y (signal_3), .\pw_audit_state_0 (signal_4));
assign defined = ((^signal_3) !== 1'bx) & ((^signal_4) !== 1'bx);
endmodule