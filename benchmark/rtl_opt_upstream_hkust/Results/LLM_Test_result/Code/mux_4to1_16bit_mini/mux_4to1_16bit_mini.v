module mux_4to1_16bit_mini #(
    parameter WIDTH = 16,
    parameter SEL_WIDTH = 2
) (
    input [WIDTH-1:0] data0,
    input [WIDTH-1:0] data1,
    input [WIDTH-1:0] data2,
    input [WIDTH-1:0] data3,
    input [SEL_WIDTH-1:0] sel,
    output [WIDTH-1:0] out
);

    // Use a single assign statement with a case-like structure
    assign out = (sel == 2'b00) ? data0 :
                 (sel == 2'b01) ? data1 :
                 (sel == 2'b10) ? data2 :
                 /* default is 2'b11 */ data3;

endmodule