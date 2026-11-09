module mult_if (
    input [7:0] A,           
    input [4:0] C,           
    input CTRL_is_late_arriving, 
    output reg Z            
);
    reg Z1;
    wire Z2, prev_cond;

    
    assign prev_cond = (C[0] == 1'b1) || (C[1] == 1'b0) || (C[2] == 1'b1);

    always @(A or C) begin
        if (C[0] == 1'b1)
            Z1 = A[0];
        else if (C[1] == 1'b0)
            Z1 = A[1];
        else if (C[2] == 1'b1)
            Z1 = A[2];
        else if (C[4] == 1'b0)
            Z1 = A[4];
        else
            Z1 = A[5];
    end

    assign Z2 = A[3];

    always @(C or prev_cond or CTRL_is_late_arriving or Z1 or Z2) begin
        if ((C[3] == 1'b1) && (CTRL_is_late_arriving == 1'b0)) begin
            if (prev_cond)
                Z = Z1;
            else
                Z = Z2;
        end
        else
            Z = Z1;
    end

endmodule