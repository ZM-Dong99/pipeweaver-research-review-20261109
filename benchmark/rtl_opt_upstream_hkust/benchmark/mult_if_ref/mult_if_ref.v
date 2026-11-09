module mult_if_ref (
    input [7:0] A,           
    input [4:0] C,           
    input CTRL_is_late_arriving, 
    output reg Z             
);

    always @(A or C or CTRL_is_late_arriving) begin
        if (C[0] == 1'b1)
            Z = A[0];
        else if (C[1] == 1'b0)
            Z = A[1];
        else if (C[2] == 1'b1)
            Z = A[2];
        else if (C[3] == 1'b1 && CTRL_is_late_arriving == 1'b0)
            Z = A[3];
        else if (C[4] == 1'b0)
            Z = A[4];
        else
            Z = A[5];
    end

endmodule