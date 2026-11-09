module mult_if_gpt (
    input [7:0] A,           
    input [4:0] C,           
    input CTRL_is_late_arriving, 
    output reg Z            
);
    wire prev_cond = (C[0] || ~C[1] || C[2]);
    reg Z1;
    wire Z2 = A[3];

    always @(*) begin
        case (1'b1)  // Use case statement for better optimization
            C[0]: Z1 = A[0];
            ~C[1]: Z1 = A[1];
            C[2]: Z1 = A[2];
            ~C[4]: Z1 = A[4];
            default: Z1 = A[5];
        endcase
    end

    always @(*) begin
        if (C[3] && ~CTRL_is_late_arriving) begin
            Z = prev_cond ? Z1 : Z2;
        end else begin
            Z = Z1;
        end
    end

endmodule