module selector_mini (
    input clk,            
    input [3:0] sel,       
    output reg [6:0] dout 
);

always @(posedge clk) begin
    dout <= 10 + {3'b000,sel} * 3;
end

endmodule