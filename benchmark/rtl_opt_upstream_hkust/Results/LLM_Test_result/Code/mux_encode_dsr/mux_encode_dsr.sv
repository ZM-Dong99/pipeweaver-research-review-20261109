module mux_encode_dsr (
    input wire [2:0] sel,         
    input wire [7:0] data [0:7],  
    output reg [7:0] out     
);

always @(*) begin
    out = data[sel];
end

endmodule