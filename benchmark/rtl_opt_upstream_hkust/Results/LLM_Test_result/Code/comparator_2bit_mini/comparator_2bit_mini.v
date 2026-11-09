module comparator_2bit_mini (
    input [1:0] A, B,
    output eq, gt, lt
);
    assign eq = (A == B);
    assign gt = (A > B);
    assign lt = (A < B);
endmodule