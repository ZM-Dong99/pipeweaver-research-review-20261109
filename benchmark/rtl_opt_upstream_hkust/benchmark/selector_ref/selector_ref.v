module selector_ref (
    input clk,             // Clock input
    input [3:0] sel,       // 2-bit selection input
    output reg [6:0] dout  // 5-bit data output
);

always @(posedge clk) begin
    case(sel)
        4'd0    : dout <= 7'd10;  // Decimal 10 when sel is 0
        4'd1    : dout <= 7'd13;  // Decimal 13 when sel is 1
        4'd2    : dout <= 7'd16;  // Decimal 16 when sel is 2
        4'd3    : dout <= 7'd19;
        4'd4    : dout <= 7'd22;
        4'd5    : dout <= 7'd25;
        4'd6    : dout <= 7'd28;
        4'd7    : dout <= 7'd31;
        4'd8    : dout <= 7'd34;
        4'd9    : dout <= 7'd37;
        4'd10    : dout <= 7'd40;
        4'd11    : dout <= 7'd43;
        4'd12    : dout <= 7'd46;
        4'd13    : dout <= 7'd49;
        4'd14    : dout <= 7'd52;
        default : dout <= 7'd55;  
    endcase
end

endmodule