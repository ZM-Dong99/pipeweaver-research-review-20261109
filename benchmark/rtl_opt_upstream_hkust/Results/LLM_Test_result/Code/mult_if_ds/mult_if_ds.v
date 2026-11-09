module mult_if_ds (
    input [7:0] A,
    input [4:0] C,
    input CTRL_is_late_arriving,
    output reg Z
);
    reg Z1;
    wire Z2 = A[3];
    wire prev_cond = (C[0] || !C[1] || C[2]);

    always @(*) begin
        casez ({C[0], C[1], C[2], C[4]})
            4'b1???: Z1 = A[0];
            4'b00??: Z1 = A[1];
            4'b?1?1: Z1 = A[2];
            4'b??01: Z1 = A[4];
            default: Z1 = A[5];
        endcase
    end

    always @(*) begin
        if (C[3] && !CTRL_is_late_arriving)
            Z = prev_cond ? Z1 : Z2;
        else
            Z = Z1;
    end
endmodule