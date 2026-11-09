module mult_if_mini (
    input [7:0] A,
    input [4:0] C,
    input CTRL_is_late_arriving,
    output reg Z
);

    wire Z1_mux_out;
    wire prev_cond;
    wire Z2 = A[3];

    assign prev_cond = (C[0] == 1'b1) || (C[1] == 1'b0) || (C[2] == 1'b1);

    // Optimized Z1 logic - direct assignment using conditional operator
    assign Z1_mux_out = (C[0] == 1'b1) ? A[0] :
                        (C[1] == 1'b0) ? A[1] :
                        (C[2] == 1'b1) ? A[2] :
                        (C[4] == 1'b0) ? A[4] :
                        A[5];

    always @(*) begin
        if ((C[3] == 1'b1) && (CTRL_is_late_arriving == 1'b0)) begin
            if (prev_cond)
                Z = Z1_mux_out;
            else
                Z = Z2;
        end
        else
            Z = Z1_mux_out;
    end

endmodule