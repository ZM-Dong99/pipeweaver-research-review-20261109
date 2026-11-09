module mult_if_dsr (
    input [7:0] A,
    input [4:0] C,
    input CTRL_is_late_arriving,
    output reg Z
);
    reg Z1;
    wire Z2, prev_cond;

    assign prev_cond = C[0] | ~C[1] | C[2];
    assign Z2 = A[3];

    always @(*) begin
        casex ({C[0], C[1], C[2], C[4]})
            4'b1xxx: Z1 = A[0];
            4'b0?0?: Z1 = A[1];
            4'b0?1?: Z1 = A[2];
            4'b0??0: Z1 = A[4];
            default:  Z1 = A[5];
        endcase
    end

    always @(*) begin
        Z = (C[3] & ~CTRL_is_late_arriving & ~prev_cond) ? Z2 : Z1;
    end
endmodule