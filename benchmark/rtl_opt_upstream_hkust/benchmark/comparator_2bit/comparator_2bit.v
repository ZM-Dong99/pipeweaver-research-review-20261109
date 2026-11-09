module comparator_2bit (
    input [1:0] A, B,
    output eq, gt, lt
);
    assign eq = (A[1] == B[1]) && (A[0] == B[0]);
    assign gt = (A[1] > B[1]) || ((A[1] == B[1]) && (A[0] > B[0]));
    assign lt = (A[1] < B[1]) || ((A[1] == B[1]) && (A[0] < B[0]));
endmodule