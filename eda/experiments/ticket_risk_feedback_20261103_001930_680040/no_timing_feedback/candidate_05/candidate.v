module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    reg rdy_q, disp_q, rtn_q;
    reg bill10_q, bill20_q, bill30_q;

    wire take_ten;
    wire take_twenty;
    wire hold_credit;

    assign take_ten    = ten;
    assign take_twenty = ~ten & twenty;
    assign hold_credit = ~ten & ~twenty;

    always @(posedge clk) begin
        if (clear) begin
            rdy_q    <= 1'b1;
            disp_q   <= 1'b0;
            rtn_q    <= 1'b0;
            bill10_q <= 1'b0;
            bill20_q <= 1'b0;
            bill30_q <= 1'b0;
        end else begin
            rdy_q    <= disp_q | rtn_q | (rdy_q & hold_credit);
            bill10_q <= (rdy_q & take_ten)
                      | (bill10_q & hold_credit);
            bill20_q <= (rdy_q & take_twenty)
                      | (bill10_q & take_ten)
                      | (bill20_q & hold_credit);
            bill30_q <= (bill10_q & take_twenty)
                      | (bill20_q & take_ten)
                      | (bill30_q & hold_credit);
            disp_q   <= (bill20_q & take_twenty)
                      | (bill30_q & take_ten);
            rtn_q    <= bill30_q & take_twenty;
        end
    end

    always @* begin
        ready      = rdy_q ? ON : OFF;
        dispense   = disp_q ? ON : OFF;
        return_sig = rtn_q ? ON : OFF;
        bill       = (bill10_q | bill20_q | bill30_q) ? ON : OFF;
    end

endmodule
