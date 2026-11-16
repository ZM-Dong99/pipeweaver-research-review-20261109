module pw_definedness(signal_0, signal_1, signal_2, signal_3, signal_4, signal_5, defined);
input [0:0] signal_0;
input [0:0] signal_1;
input [15:0] signal_2;
input [15:0] signal_3;
input [2:0] signal_4;
input [0:0] signal_5;
wire [15:0] signal_6;
wire [0:0] signal_7;
wire [15:0] signal_8;
wire [15:0] signal_9;
wire [2:0] signal_10;
wire [0:0] signal_11;
wire [15:0] signal_12;
wire [0:0] signal_13;
output defined;
pw_pipeline_alu dut(.\clk (signal_0), .\rst (signal_1), .\a (signal_2), .\b (signal_3), .\Oper (signal_4), .\in_valid (signal_5), .\result (signal_6), .\out_valid (signal_7), .\pw_audit_state_557 (signal_8), .\pw_audit_state_558 (signal_9), .\pw_audit_state_559 (signal_10), .\pw_audit_state_560 (signal_11), .\pw_audit_state_561 (signal_12), .\pw_audit_state_562 (signal_13));
assign defined = ((^signal_6) !== 1'bx) & ((^signal_7) !== 1'bx) & ((^signal_8) !== 1'bx) & ((^signal_9) !== 1'bx) & ((^signal_10) !== 1'bx) & ((^signal_11) !== 1'bx) & ((^signal_12) !== 1'bx) & ((^signal_13) !== 1'bx);
endmodule