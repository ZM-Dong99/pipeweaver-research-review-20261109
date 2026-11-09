module selector (
    input clk,            
    input [3:0] sel,       
    output reg [6:0] dout 
);

wire [6:0] dout_next;      

// Combinational logic
assign dout_next = 10 + sel*3;

// Sequential logic (clocked)
always @(posedge clk) begin
    dout <= dout_next;
end

endmodule