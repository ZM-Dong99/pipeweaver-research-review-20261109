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

    wire take_ten;
    wire take_twenty;
    wire idle;
    wire coin;

    assign take_ten    = ten;
    assign take_twenty = twenty & ~ten;
    assign idle        = ~(ten | twenty);
    assign coin        = ten | twenty;

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
            s_ready  <= s_disp | s_return | (s_ready & idle);
            s_disp   <= (s_bill20 & take_twenty) |
                        (s_bill30 & take_ten);
            s_return <= s_bill30 & take_twenty;

            s_bill10 <= (s_ready & take_ten) |
                        (s_bill10 & idle);
            s_bill20 <= (s_ready & take_twenty) |
                        (s_bill10 & take_ten) |
                        (s_bill20 & idle);
            s_bill30 <= (s_bill10 & take_twenty) |
                        (s_bill20 & take_ten) |
                        (s_bill30 & idle);

            bill_active <= (s_ready & coin) |
                           s_bill10 |
                           (s_bill20 & (ten | ~twenty)) |
                           (s_bill30 & idle);
        end
    end

    always @* begin
        ready      = s_ready    ? ON : OFF;
        dispense   = s_disp     ? ON : OFF;
        return_sig = s_return   ? ON : OFF;
        bill       = bill_active ? ON : OFF;
    end

endmodule
