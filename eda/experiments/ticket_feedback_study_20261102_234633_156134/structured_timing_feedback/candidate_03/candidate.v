module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    reg s_ready, s_disp, s_return;
    reg s_bill10, s_bill20, s_bill30;

    wire take_twenty = twenty & ~ten;
    wire idle_input  = ~(ten | twenty);
    wire accept_bill = ten | twenty;

    // Explicit one-hot transitions retain ten's priority over twenty.
    // All state and output storage uses the same synchronous reset.
    always @(posedge clk) begin
        if (clear) begin
            s_ready  <= 1'b1;
            s_disp   <= 1'b0;
            s_return <= 1'b0;
            s_bill10 <= 1'b0;
            s_bill20 <= 1'b0;
            s_bill30 <= 1'b0;
            bill     <= OFF;
        end else begin
            s_ready <= s_disp | s_return | (s_ready & idle_input);
            s_disp <= (s_bill20 & take_twenty) | (s_bill30 & ten);
            s_return <= s_bill30 & take_twenty;
            s_bill10 <= (s_ready & ten) | (s_bill10 & idle_input);
            s_bill20 <= (s_ready & take_twenty)
                      | (s_bill10 & ten)
                      | (s_bill20 & idle_input);
            s_bill30 <= (s_bill10 & take_twenty)
                      | (s_bill20 & ten)
                      | (s_bill30 & idle_input);

            // This is the bill indication of the state being entered,
            // not a delayed copy of the current state's bill indication.
            bill <= ((s_ready & accept_bill)
                   | s_bill10
                   | (s_bill20 & ~take_twenty)
                   | (s_bill30 & idle_input)) ? ON : OFF;
        end
    end

    always @* begin
        ready      = s_ready  ? ON : OFF;
        dispense   = s_disp   ? ON : OFF;
        return_sig = s_return ? ON : OFF;
    end

endmodule
