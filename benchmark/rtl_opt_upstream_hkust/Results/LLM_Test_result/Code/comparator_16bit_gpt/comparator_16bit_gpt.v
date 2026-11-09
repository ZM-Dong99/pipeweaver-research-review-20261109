module comparator_16bit_gpt (
    input [15:0] A,       
    input [15:0] B,       
    output gt,           
    output eq,           
    output lt            
);

    // Combinational logic for comparison
    wire [15:0] diff = A - B;

    assign eq = (diff == 16'b0);   // A equals B
    assign gt = (diff[15] == 1'b0) & (|diff[14:0]); // A greater than B
    assign lt = (diff[15] == 1'b1); // A less than B

endmodule