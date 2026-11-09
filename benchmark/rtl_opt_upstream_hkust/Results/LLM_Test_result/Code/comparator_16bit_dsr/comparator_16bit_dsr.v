module comparator_16bit_dsr (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);

    wire neq;
    assign eq = (A == B);
    assign neq = ~eq;
    assign gt = (A > B);
    assign lt = neq & ~gt;

endmodule