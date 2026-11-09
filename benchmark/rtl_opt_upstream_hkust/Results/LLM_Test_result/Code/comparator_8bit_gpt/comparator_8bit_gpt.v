module comparator_8bit_gpt (
    input [7:0] A, B,
    output eq, gt, lt
);
    wire [7:0] diff = A - B;

    assign eq = (A == B);
    assign gt = (diff[7] == 0) && (|diff[6:0]);
    assign lt = (diff[7] != 0);

endmodule