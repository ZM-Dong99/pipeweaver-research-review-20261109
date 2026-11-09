module mux_4to1_16bit_gpt #(
    parameter WIDTH = 16,
    parameter SEL_WIDTH = 2
) (
    input [WIDTH-1:0] data0,
    input [WIDTH-1:0] data1,
    input [WIDTH-1:0] data2,
    input [WIDTH-1:0] data3,
    input [SEL_WIDTH-1:0] sel,
    output reg [WIDTH-1:0] out
);

    always @(*) begin
        case(sel)
            2'b00: out = data0;
            2'b01: out = data1;
            2'b10: out = data2;
            2'b11: out = data3;
            default: out = {WIDTH{1'b0}}; // Default case to avoid latches
        endcase
    end
endmodule