module mux_4to1_16bit #(
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
    wire [WIDTH-1:0] temp0, temp1, temp2, temp3;
    
   
    assign temp0 = (sel == 0) ? data0 : {WIDTH{1'b0}};
    assign temp1 = (sel == 1) ? data1 : {WIDTH{1'b0}};
    assign temp2 = (sel == 2) ? data2 : {WIDTH{1'b0}};
    assign temp3 = (sel == 3) ? data3 : {WIDTH{1'b0}};
    

    assign out = temp0 | temp1 | temp2 | temp3;
endmodule