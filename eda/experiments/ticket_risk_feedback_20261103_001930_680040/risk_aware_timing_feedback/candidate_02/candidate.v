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
    wire no_payment = ~(ten | twenty);
    wire any_payment = ten | twenty;

    wire next_ready = s_disp | s_return | (s_ready & no_payment);
    wire next_bill10 = (s_ready & ten) | (s_bill10 & no_payment);
    wire next_bill20 = (s_ready & take_twenty)
                    | (s_bill10 & ten)
                    | (s_bill20 & no_payment);
    wire next_bill30 = (s_bill10 & take_twenty)
                    | (s_bill20 & ten)
                    | (s_bill30 & no_payment);
    wire next_disp = (s_bill20 & take_twenty) | (s_bill30 & ten);
    wire next_return = s_bill30 & take_twenty;

    // Union of the three next billing states, factored independently
    // of their individual next-state equations.
    wire next_bill_active = (s_ready & any_payment)
                          | s_bill10
                          | (s_bill20 & (ten | ~twenty))
                          | (s_bill30 & no_payment);

    always @(posedge clk) begin
        if (clear) begin
            s_ready     <= 1'b1;
            s_disp      <= 1'b0;
            s_return    <= 1'b0;
            s_bill10    <= 1'b0;
            s_bill20    <= 1'b0;
            s_bill30    <= 1'b0;
            bill_active <= 1'b0;
        end else begin
            s_ready     <= next_ready;
            s_disp      <= next_disp;
            s_return    <= next_return;
            s_bill10    <= next_bill10;
            s_bill20    <= next_bill20;
            s_bill30    <= next_bill30;
            bill_active <= next_bill_active;
        end
    end

    always @* begin
        ready      = s_ready     ? ON : OFF;
        dispense   = s_disp      ? ON : OFF;
        return_sig = s_return    ? ON : OFF;
        bill       = bill_active ? ON : OFF;
    end

endmodule
