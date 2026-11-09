module mux_4to1_64bit_mini #(
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
    assign out = (sel == 2'd0) ? data0 :
                 (sel == 2'd1) ? data1 :
                 (sel == 2'd2) ? data2 :
                 data3;
endmodule