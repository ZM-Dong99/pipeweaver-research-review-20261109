module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    // Mixed-polarity one-hot state: bill-state bits are active low.
    reg rdy_q, disp_q, rtn_q;
    reg b10_n, b20_n, b30_n;

    wire take_ten    = ten;
    wire take_twenty = ~ten & twenty;
    wire hold_money  = ~ten & ~twenty;

    wire b10 = ~b10_n;
    wire b20 = ~b20_n;
    wire b30 = ~b30_n;

    always @(posedge clk) begin
        if (clear) begin
            rdy_q  <= 1'b1;
            disp_q <= 1'b0;
            rtn_q  <= 1'b0;
            b10_n  <= 1'b1;
            b20_n  <= 1'b1;
            b30_n  <= 1'b1;
        end else begin
            rdy_q  <= disp_q | rtn_q | (rdy_q & hold_money);
            disp_q <= (b20 & take_twenty) | (b30 & take_ten);
            rtn_q  <= b30 & take_twenty;

            b10_n <= ~((rdy_q & take_ten) |
                       (b10 & hold_money));
            b20_n <= ~((rdy_q & take_twenty) |
                       (b10 & take_ten) |
                       (b20 & hold_money));
            b30_n <= ~((b10 & take_twenty) |
                       (b20 & take_ten) |
                       (b30 & hold_money));
        end
    end

    always @* begin
        ready      = rdy_q  ? ON : OFF;
        dispense   = disp_q ? ON : OFF;
        return_sig = rtn_q  ? ON : OFF;
        bill       = (~(b10_n & b20_n & b30_n)) ? ON : OFF;
    end

endmodule
