module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    // State bits: RDY, DISP, RTN, BILL10, BILL20, BILL30.
    reg [5:0] State;
    wire take_ten;
    wire take_twenty;
    wire hold_credit;
    wire [5:0] NextState;

    assign take_ten    = ten;
    assign take_twenty = ~ten & twenty;
    assign hold_credit = ~ten & ~twenty;

    // Direct one-hot transition equations avoid full-vector state decoding.
    assign NextState[0] = State[1] | State[2]
                        | (State[0] & hold_credit);
    assign NextState[1] = (State[4] & take_twenty)
                        | (State[5] & take_ten);
    assign NextState[2] = State[5] & take_twenty;
    assign NextState[3] = (State[0] & take_ten)
                        | (State[3] & hold_credit);
    assign NextState[4] = (State[0] & take_twenty)
                        | (State[3] & take_ten)
                        | (State[4] & hold_credit);
    assign NextState[5] = (State[3] & take_twenty)
                        | (State[4] & take_ten)
                        | (State[5] & hold_credit);

    always @(posedge clk) begin
        if (clear)
            State <= 6'b000001;
        else
            State <= NextState;
    end

    always @* begin
        ready      = State[0] ? ON : OFF;
        dispense   = State[1] ? ON : OFF;
        return_sig = State[2] ? ON : OFF;
        bill       = (State[3] | State[4] | State[5]) ? ON : OFF;
    end

endmodule
