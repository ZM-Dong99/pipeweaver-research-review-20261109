`timescale 1ns/1ps
module tb;
reg clk=0,rst=0; reg [7:0] data=0; reg keep=0,valid=0,last=0,user=0;
wire [31:0] gf,cf; wire gv,cv,gr,cr;
reg [45:0] vectors[0:4095]; reg [31:0] expected; reg expected_valid; integer i;
gold_fcs gold(.clk(clk),.rst(rst),.s_axis_tdata(data),.s_axis_tkeep(keep),.s_axis_tvalid(valid),.s_axis_tlast(last),.s_axis_tuser(user),.output_fcs(gf),.output_fcs_valid(gv),.s_axis_tready(gr));
opt_fcs cand(.clk(clk),.rst(rst),.s_axis_tdata(data),.s_axis_tkeep(keep),.s_axis_tvalid(valid),.s_axis_tlast(last),.s_axis_tuser(user),.output_fcs(cf),.output_fcs_valid(cv),.s_axis_tready(cr));
initial begin
  $readmemh("vectors.hex",vectors);
  for(i=0;i<4096;i=i+1) begin
    #5; clk=0; {rst,data,valid,last,keep,user,expected,expected_valid}=vectors[i];
    #5; clk=1; #1;
    if(gf !== expected || cf !== expected || gv !== expected_valid || cv !== expected_valid || gr !== 1'b1 || cr !== 1'b1) $fatal(1,"Mismatch at %0d",i);
  end
  $display("PASS 4096 cycles, reset complete, standard CRC32 check and independent oracle");
  $finish;
end
endmodule
