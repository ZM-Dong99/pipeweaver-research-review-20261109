module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    // Binary state encoding preserves the original state transitions.
    localparam [2:0] RDY    = 3'd0,
                     BILL10 = 3'd1,
                     BILL20 = 3'd2,
                     BILL30 = 3'd3,
                     DISP   = 3'd4,
                     RTN    = 3'd5;

    reg [2:0] State, NextState;

    always @(posedge clk) begin
        if (clear)
            State <= RDY;
        else
            State <= NextState;
    end

    always @* begin
        ready      = OFF;
        dispense   = OFF;
        return_sig = OFF;
        bill       = OFF;

        case (State)
            RDY: begin
                ready = ON;
            end

            BILL10,
            BILL20,
            BILL30: begin
                bill = ON;
            end

            DISP: begin
                dispense = ON;
            end

            RTN: begin
                return_sig = ON;
            end

            default: begin
            end
        endcase
    end

    always @* begin
        case (State)
            RDY: begin
                if (ten)
                    NextState = BILL10;
                else if (twenty)
                    NextState = BILL20;
                else
                    NextState = RDY;
            end

            BILL10: begin
                if (ten)
                    NextState = BILL20;
                else if (twenty)
                    NextState = BILL30;
                else
                    NextState = BILL10;
            end

            BILL20: begin
                if (ten)
                    NextState = BILL30;
                else if (twenty)
                    NextState = DISP;
                else
                    NextState = BILL20;
            end

            BILL30: begin
                if (ten)
                    NextState = DISP;
                else if (twenty)
                    NextState = RTN;
                else
                    NextState = BILL30;
            end

            DISP,
            RTN: begin
                NextState = RDY;
            end

            default: begin
                NextState = RDY;
            end
        endcase
    end

endmodule
