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
    wire idle        = ~(ten | twenty);
    wire coin        = ten | twenty;

    wire next_ready  = (s_ready & idle) | s_disp | s_return;
    wire next_disp   = (s_bill20 & take_twenty) | (s_bill30 & ten);
    wire next_return = s_bill30 & take_twenty;
    wire next_bill10 = (s_ready & ten) | (s_bill10 & idle);
    wire next_bill20 = (s_ready & take_twenty) |
                       (s_bill10 & ten) | (s_bill20 & idle);
    wire next_bill30 = (s_bill10 & take_twenty) |
                       (s_bill20 & ten) | (s_bill30 & idle);

    // Look ahead to the bill output of the state entered on this edge.
    wire next_bill = (s_ready & coin) |
                     s_bill10 |
                     (s_bill20 & ~take_twenty) |
                     (s_bill30 & idle);

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
            s_ready  <= next_ready;
            s_disp   <= next_disp;
            s_return <= next_return;
            s_bill10 <= next_bill10;
            s_bill20 <= next_bill20;
            s_bill30 <= next_bill30;
            bill     <= next_bill ? ON : OFF;
        end
    end

    always @* begin
        ready      = s_ready  ? ON : OFF;
        dispense   = s_disp   ? ON : OFF;
        return_sig = s_return ? ON : OFF;
    end

endmodule
