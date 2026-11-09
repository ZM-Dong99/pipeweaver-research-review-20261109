module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    reg s_ready, s_disp, s_return;
    reg s_bill10, s_bill20, s_bill30;
    reg bill_active;

    wire take_twenty = twenty & ~ten;
    wire hold_credit = ~(ten | twenty);

    wire n_ready = s_disp | s_return | (s_ready & hold_credit);
    wire n_bill10 = (s_ready & ten) |
                   (s_bill10 & hold_credit);
    wire n_bill20 = (s_ready & take_twenty) |
                   (s_bill10 & ten) |
                   (s_bill20 & hold_credit);
    wire n_bill30 = (s_bill10 & take_twenty) |
                   (s_bill20 & ten) |
                   (s_bill30 & hold_credit);
    wire n_disp = (s_bill20 & take_twenty) |
                  (s_bill30 & ten);
    wire n_return = s_bill30 & take_twenty;
    wire n_bill_active = n_bill10 | n_bill20 | n_bill30;

    always @(posedge clk) begin
        if (clear) begin
            s_ready    <= 1'b1;
            s_disp     <= 1'b0;
            s_return   <= 1'b0;
            s_bill10   <= 1'b0;
            s_bill20   <= 1'b0;
            s_bill30   <= 1'b0;
            bill_active <= 1'b0;
        end else begin
            s_ready    <= n_ready;
            s_disp     <= n_disp;
            s_return   <= n_return;
            s_bill10   <= n_bill10;
            s_bill20   <= n_bill20;
            s_bill30   <= n_bill30;
            bill_active <= n_bill_active;
        end
    end

    always @* begin
        ready      = s_ready     ? ON : OFF;
        dispense   = s_disp      ? ON : OFF;
        return_sig = s_return    ? ON : OFF;
        bill       = bill_active ? ON : OFF;
    end

endmodule
