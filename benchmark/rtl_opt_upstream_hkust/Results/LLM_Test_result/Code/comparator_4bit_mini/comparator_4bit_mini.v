module comparator_4bit_mini (
    input [3:0] A, B,
    output eq, gt, lt
);

    assign eq = (A == B);
    assign gt = (A > B);
    assign lt = (A < B);

endmodule