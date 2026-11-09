module add_sub_mini (
    input [15:0] a, b,
    input control,
    output [15:0] result
);

    assign result = control ? (a + b) : (a - b);

endmodule