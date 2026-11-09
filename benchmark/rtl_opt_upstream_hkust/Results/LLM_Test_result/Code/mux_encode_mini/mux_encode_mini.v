module mux_encode_mini (
    input wire [2:0] sel,         
    input wire [7:0] data [0:7],  
    output wire [7:0] out     
);

assign out = data[sel];

endmodule