module tb;
reg [7:0] A; reg [3:0] B;
wire [7:0] qg,rg,qr,rr;
divider_8bit g(A,B,qg,rg);
divider_8bit_ref r(A,B,qr,rr);
integer a,b,zero_diff=0,nonzero_diff=0,shown=0;
initial begin
for(a=0;a<256;a=a+1) begin
for(b=0;b<16;b=b+1) begin
A=a; B=b; #1;
if(qg!==qr || rg!==rr) begin
if(b==0) zero_diff=zero_diff+1; else nonzero_diff=nonzero_diff+1;
if(shown<3) begin $display("DIFF A=%0d B=%0d gold_q=%0d ref_q=%0d gold_r=%0d ref_r=%0d",A,B,qg,qr,rg,rr); shown=shown+1; end
end
end
end
$display("EXHAUSTIVE cases=4096 zero_divisor_mismatches=%0d nonzero_divisor_mismatches=%0d",zero_diff,nonzero_diff);
$finish;
end
endmodule
