module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    // State bits: ready, dispense, return, bill10, bill20, bill30.
    reg [5:0] State;

    wire take_ten;
    wire take_twenty;
    wire hold_amount;

    assign take_ten    = ten;
    assign take_twenty = ~ten & twenty;
    assign hold_amount = ~(ten | twenty);

    // Direct one-hot transition equations, with synchronous reset.
    always @(posedge clk) begin
        if (clear) begin
            State <= 6'b000001;
        end else begin
            State[0] <= State[1] | State[2]
                      | (State[0] & hold_amount);
            State[1] <= (State[4] & take_twenty)
                      | (State[5] & take_ten);
            State[2] <= State[5] & take_twenty;
            State[3] <= (State[0] & take_ten)
                      | (State[3] & hold_amount);
            State[4] <= (State[0] & take_twenty)
                      | (State[3] & take_ten)
                      | (State[4] & hold_amount);
            State[5] <= (State[3] & take_twenty)
                      | (State[4] & take_ten)
                      | (State[5] & hold_amount);
        end
    end

    always @* begin
        ready      = State[0] ? ON : OFF;
        dispense   = State[1] ? ON : OFF;
        return_sig = State[2] ? ON : OFF;
        bill       = (State[3] | State[4] | State[5]) ? ON : OFF;
    end

endmodule
