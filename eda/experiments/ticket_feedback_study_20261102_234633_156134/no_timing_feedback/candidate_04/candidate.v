module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    // Reachable-state one-hot representation, established by clear.
    reg s_ready, s_disp, s_return;
    reg s_bill10, s_bill20, s_bill30;

    wire take10;
    wire take20;
    wire hold_amount;

    assign take10      = ten;
    assign take20      = ~ten & twenty;
    assign hold_amount = ~ten & ~twenty;

    // Direct one-hot transition equations avoid full-state comparisons.
    always @(posedge clk) begin
        if (clear) begin
            s_ready  <= 1'b1;
            s_disp   <= 1'b0;
            s_return <= 1'b0;
            s_bill10 <= 1'b0;
            s_bill20 <= 1'b0;
            s_bill30 <= 1'b0;
        end else begin
            s_ready  <= s_disp | s_return | (s_ready & hold_amount);
            s_disp   <= (s_bill20 & take20) | (s_bill30 & take10);
            s_return <= s_bill30 & take20;
            s_bill10 <= (s_ready & take10) | (s_bill10 & hold_amount);
            s_bill20 <= (s_ready & take20) | (s_bill10 & take10)
                      | (s_bill20 & hold_amount);
            s_bill30 <= (s_bill10 & take20) | (s_bill20 & take10)
                      | (s_bill30 & hold_amount);
        end
    end

    always @* begin
        ready      = s_ready ? ON : OFF;
        dispense   = s_disp ? ON : OFF;
        return_sig = s_return ? ON : OFF;
        bill       = (s_bill10 | s_bill20 | s_bill30) ? ON : OFF;
    end

endmodule
