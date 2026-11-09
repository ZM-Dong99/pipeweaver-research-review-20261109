module pw_reset(input clk,rst,input [7:0] data,input keep,valid,last,user,output mismatch,
output [31:0] observed_fcs,observed_state,output observed_valid,observed_ready);
pw_dut dut(.clk(clk),.rst(rst),.s_axis_tdata(data),.s_axis_tkeep(keep),.s_axis_tvalid(valid),
.s_axis_tlast(last),.s_axis_tuser(user),.output_fcs(observed_fcs),.output_fcs_valid(observed_valid),
.s_axis_tready(observed_ready),.crc_state(observed_state));
assign mismatch=(observed_fcs != 32'b0) | (observed_state != 32'hffffffff) | observed_valid | !observed_ready;
endmodule
