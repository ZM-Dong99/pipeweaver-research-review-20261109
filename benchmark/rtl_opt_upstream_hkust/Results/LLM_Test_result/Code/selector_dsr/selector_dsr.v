module selector_dsr (
    input clk,
    input [3:0] sel,
    output reg [6:0] dout
);

always @(posedge clk) begin
    dout <= {1'b0, (sel << 1) + sel + 6'd10};
end

endmodule