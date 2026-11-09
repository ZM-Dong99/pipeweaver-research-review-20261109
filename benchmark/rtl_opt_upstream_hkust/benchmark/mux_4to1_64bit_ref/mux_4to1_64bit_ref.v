module mux_4to1_64bit_ref #(
    parameter WIDTH = 64,
    parameter SEL_WIDTH = 2
) (
    input [WIDTH-1:0] data0,
    input [WIDTH-1:0] data1,
    input [WIDTH-1:0] data2,
    input [WIDTH-1:0] data3,
    input [SEL_WIDTH-1:0] sel,
    output [WIDTH-1:0] out
);
    reg [WIDTH-1:0] lut [0:(1<<SEL_WIDTH)-1];
    
    always @(*) begin
        lut[0] = data0;
        lut[1] = data1;
        lut[2] = data2;
        lut[3] = data3;
    end
    
    assign out = lut[sel];
endmodule