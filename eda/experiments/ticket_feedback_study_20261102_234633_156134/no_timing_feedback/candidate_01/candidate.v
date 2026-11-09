module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    // State bits: ready, dispense, return, bill10, bill20, bill30.
    reg [5:0] state;

    wire idle;
    wire take_twenty;
    assign idle = ~ten & ~twenty;
    assign take_twenty = ~ten & twenty;

    // Explicit one-hot transition equations. A ten input takes priority.
    always @(posedge clk) begin
        if (clear) begin
            state <= 6'b000001;
        end else begin
            state[0] <= state[1] | state[2] | (state[0] & idle);
            state[1] <= (state[4] & take_twenty) | (state[5] & ten);
            state[2] <= state[5] & take_twenty;
            state[3] <= (state[0] & ten) | (state[3] & idle);
            state[4] <= (state[0] & take_twenty) |
                        (state[3] & ten) |
                        (state[4] & idle);
            state[5] <= (state[3] & take_twenty) |
                        (state[4] & ten) |
                        (state[5] & idle);
        end
    end

    always @* begin
        ready      = state[0] ? ON : OFF;
        dispense   = state[1] ? ON : OFF;
        return_sig = state[2] ? ON : OFF;
        bill       = (state[3] | state[4] | state[5]) ? ON : OFF;
    end

endmodule
