module selector_ds (
    input clk,
    input [3:0] sel,
    output reg [6:0] dout
);

wire [6:0] dout_next = 10 + sel * 3;

always @(posedge clk) begin
    dout <= dout_next;
end

endmodule