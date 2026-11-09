module mux_encode_gpt (
    input wire [2:0] sel,         
    input wire [7:0] data [0:7],  
    output reg [7:0] out     
);

always @(*) begin
    out = (sel < 3'b100) ? data[sel] : 8'b0;
end

endmodule