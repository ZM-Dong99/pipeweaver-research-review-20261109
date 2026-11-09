module mux_encode (
    input wire [2:0] sel,         
    input wire [7:0] data [0:7],  
    output reg [7:0] out     
);

always @(*) begin
    case (sel)
        3'b000: out = data[0];
        3'b001: out = data[1];
        3'b010: out = data[2];
        3'b011: out = data[3];
        3'b100: out = data[4];
        3'b101: out = data[5];
        3'b110: out = data[6];
        3'b111: out = data[7];
        default: out = 8'b0;
    endcase
end

endmodule