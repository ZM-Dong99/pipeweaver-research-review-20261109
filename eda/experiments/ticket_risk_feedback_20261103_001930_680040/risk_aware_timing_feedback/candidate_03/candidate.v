module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    reg s_ready, s_disp, s_return;
    reg s_bill10, s_bill20, s_bill30;
    reg bill_q;

    wire take_ten = ten;
    wire take_twenty = twenty & ~ten;
    wire idle = ~ten & ~twenty;
    wire active = ten | twenty;

    wire n_ready = s_disp | s_return | (s_ready & idle);
    wire n_bill10 = (s_ready & take_ten) | (s_bill10 & idle);
    wire n_bill20 = (s_ready & take_twenty)
                  | (s_bill10 & take_ten)
                  | (s_bill20 & idle);
    wire n_bill30 = (s_bill10 & take_twenty)
                  | (s_bill20 & take_ten)
                  | (s_bill30 & idle);
    wire n_disp = (s_bill20 & take_twenty)
                | (s_bill30 & take_ten);
    wire n_return = s_bill30 & take_twenty;

    // True exactly when the destination state is a bill state.
    wire n_bill = (s_ready & active)
                | s_bill10
                | (s_bill20 & ~take_twenty)
                | (s_bill30 & idle);

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
            s_ready  <= n_ready;
            s_disp   <= n_disp;
            s_return <= n_return;
            s_bill10 <= n_bill10;
            s_bill20 <= n_bill20;
            s_bill30 <= n_bill30;
            bill_q   <= n_bill;
        end
    end

    always @* begin
        ready      = s_ready  ? ON : OFF;
        dispense   = s_disp   ? ON : OFF;
        return_sig = s_return ? ON : OFF;
        bill       = bill_q   ? ON : OFF;
    end

endmodule
