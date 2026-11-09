module mux_encode_ref (
    input wire [2:0] sel,         // 3-bit binary select
    input wire [7:0] data [0:7],  // 8 input data ports
    output reg [7:0] out     // Output
);

always @(*) begin
    out = 8'b0;  // Default value
    
    if (sel[0]) out = data[0];
    if (sel[1]) out = data[1];
    if (sel[2]) out = data[2];
    if (sel[3]) out = data[3];
    if (sel[4]) out = data[4];
    if (sel[5]) out = data[5];
    if (sel[6]) out = data[6];
    if (sel[7]) out = data[7];
end


endmodule