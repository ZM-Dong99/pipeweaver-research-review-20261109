module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    // Explicit one-hot state bits, plus a redundant registered bill decode.
    reg s_ready, s_disp, s_return;
    reg s_bill10, s_bill20, s_bill30;
    reg bill_q;

    wire take_ten    = ten;
    wire take_twenty = ~ten & twenty;
    wire hold_money  = ~ten & ~twenty;

    // Compute the bill indication for the state entered at this edge.
    // BILL10 always transitions to another bill state.
    wire next_bill = s_bill10
                   | (s_ready  & (ten | twenty))
                   | (s_bill20 & (ten | ~twenty))
                   | (s_bill30 & hold_money);

    always @(posedge clk) begin
        if (clear) begin
            s_ready  <= 1'b1;
            s_disp   <= 1'b0;
            s_return <= 1'b0;
            s_bill10 <= 1'b0;
            s_bill20 <= 1'b0;
            s_bill30 <= 1'b0;
            bill_q   <= 1'b0;
        end else begin
            s_ready  <= s_disp | s_return | (s_ready & hold_money);
            s_bill10 <= (s_ready & take_ten)
                      | (s_bill10 & hold_money);
            s_bill20 <= (s_ready & take_twenty)
                      | (s_bill10 & take_ten)
                      | (s_bill20 & hold_money);
            s_bill30 <= (s_bill10 & take_twenty)
                      | (s_bill20 & take_ten)
                      | (s_bill30 & hold_money);
            s_disp   <= (s_bill20 & take_twenty)
                      | (s_bill30 & take_ten);
            s_return <= s_bill30 & take_twenty;
            bill_q   <= next_bill;
        end
    end

    always @* begin
        ready      = s_ready  ? ON : OFF;
        dispense   = s_disp   ? ON : OFF;
        return_sig = s_return ? ON : OFF;
        bill       = bill_q   ? ON : OFF;
    end

endmodule
