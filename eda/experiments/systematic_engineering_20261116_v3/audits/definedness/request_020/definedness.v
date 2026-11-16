module pw_definedness(signal_0, signal_1, signal_2, signal_3, defined);
input [0:0] signal_0;
input [0:0] signal_1;
input [0:0] signal_2;
input [7:0] signal_3;
wire [7:0] signal_4;
wire [0:0] signal_5;
wire [8:0] signal_6;
output defined;
pw_fsm_sync dut(.\clk (signal_0), .\rst (signal_1), .\start (signal_2), .\data_in (signal_3), .\data_out (signal_4), .\done (signal_5), .\pw_audit_state_36 (signal_6));
assign defined = ((^signal_4) !== 1'bx) & ((^signal_5) !== 1'bx) & ((^signal_6) !== 1'bx);
endmodule