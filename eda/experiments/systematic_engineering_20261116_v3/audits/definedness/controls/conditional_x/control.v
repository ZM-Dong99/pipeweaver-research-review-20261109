module control(input clk, rst, a, output reg y);
always @(posedge clk) if (rst) y <= 0; else y <= a ? 1'b1 : 1'bx;
endmodule
