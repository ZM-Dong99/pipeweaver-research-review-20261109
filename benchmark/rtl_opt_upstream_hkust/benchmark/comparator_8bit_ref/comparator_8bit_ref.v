module comparator_8bit_ref (
    input [7:0] A,        // First 2-bit input operand
    input [7:0] B,        // Second 2-bit input operand
    output gt,     // Output indicating A > B
    output eq,       // Output indicating A == B
    output lt         // Output indicating A < B
);

    // Combinational logic for comparison
    assign eq = (A == B);           // A equals B
    assign gt = (A > B);          // A greater than B
    assign lt = (A < B);             // A less than B

endmodule