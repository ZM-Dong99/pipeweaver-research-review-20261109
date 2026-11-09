module comparator_4bit_gpt (
    input [3:0] A, B,
    output wire eq, gt, lt
);
    wire [3:0] comp = A ^ B;

    assign eq = ~|comp;
    assign gt = (A > B);
    assign lt = (A < B);

endmodule