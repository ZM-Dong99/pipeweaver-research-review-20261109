module selector_gpt (
    input clk,            
    input [3:0] sel,       
    output reg [6:0] dout 
);

always @(posedge clk) begin
    dout <= 10 + (sel << 1) + sel; // Optimized multiplication and addition
end

endmodule