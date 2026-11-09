module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    reg s_ready, s_disp, s_return;
    reg s_bill10, s_bill20, s_bill30;

    wire take_ten    = ten;
    wire take_twenty = ~ten & twenty;
    wire idle        = ~ten & ~twenty;
    wire run         = ~clear;

    // Explicit one-hot transition equations; synchronous active-high reset.
    always @(posedge clk) begin
        s_ready  <= clear | s_disp | s_return | (s_ready & idle);
        s_bill10 <= run & ((s_ready & take_ten) |
                          (s_bill10 & idle));
        s_bill20 <= run & ((s_ready & take_twenty) |
                          (s_bill10 & take_ten) |
                          (s_bill20 & idle));
        s_bill30 <= run & ((s_bill10 & take_twenty) |
                          (s_bill20 & take_ten) |
                          (s_bill30 & idle));
        s_disp   <= run & ((s_bill20 & take_twenty) |
                          (s_bill30 & take_ten));
        s_return <= run & (s_bill30 & take_twenty);
    end

    always @* begin
        ready      = s_ready ? ON : OFF;
        dispense   = s_disp ? ON : OFF;
        return_sig = s_return ? ON : OFF;
        bill       = (s_bill10 | s_bill20 | s_bill30) ? ON : OFF;
    end

endmodule
