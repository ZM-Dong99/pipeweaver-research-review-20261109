module pw_definedness(signal_0, signal_1, signal_2, signal_3, defined);
input [0:0] signal_0;
input [0:0] signal_1;
input [31:0] signal_2;
input [31:0] signal_3;
wire [31:0] signal_4;
wire [0:0] signal_5;
wire [4:0] signal_6;
wire [31:0] signal_7;
wire [0:0] signal_8;
wire [4:0] signal_9;
wire [31:0] signal_10;
output defined;
arbiter dut(.\clk (signal_0), .\rst (signal_1), .\request (signal_2), .\acknowledge (signal_3), .\grant (signal_4), .\grant_valid (signal_5), .\grant_encoded (signal_6), .\pw_audit_state_240 (signal_7), .\pw_audit_state_241 (signal_8), .\pw_audit_state_242 (signal_9), .\pw_audit_state_243 (signal_10));
assign defined = ((^signal_4) !== 1'bx) & ((^signal_5) !== 1'bx) & ((^signal_6) !== 1'bx) & ((^signal_7) !== 1'bx) & ((^signal_8) !== 1'bx) & ((^signal_9) !== 1'bx) & ((^signal_10) !== 1'bx);
endmodule