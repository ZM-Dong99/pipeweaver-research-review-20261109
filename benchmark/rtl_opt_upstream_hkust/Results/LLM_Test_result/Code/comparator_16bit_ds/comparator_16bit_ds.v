module comparator_16bit_ds (
    input [15:0] A,
    input [15:0] B,
    output gt,
    output eq,
    output lt
);

    wire [15:0] diff = A - B;
    assign eq = (diff == 16'b0);
    assign gt = ~diff[15] & ~eq;
    assign lt = diff[15];

endmodule