module ticket_machine_mini #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    // Use a simpler state encoding if possible, like binary or sequential.
    // Binary encoding often results in smaller area.
    localparam RDY    = 3'b000,
               BILL10 = 3'b001,
               BILL20 = 3'b010,
               BILL30 = 3'b011,
               DISP   = 3'b100,
               RTN    = 3'b101;

    reg [2:0] State, NextState;

    // update state on clock rising edge
    always @(posedge clk) begin
        if (clear)
            State <= RDY;
        else
            State <= NextState;
    end

    // Combine output logic and next state logic into a single always block (Mealy style).
    // This can simplify the logic and potentially reduce area and improve performance.
    // Outputs are now assigned in the combinatorial block.
    always @(State or ten or twenty) begin
        // Default assignments for outputs and next state
        ready      = OFF;
        bill       = OFF;
        dispense   = OFF;
        return_sig = OFF;
        NextState  = State; // Assume state stays the same unless changed

        case (State)
            RDY:    begin
                ready = ON;
                if (ten)
                    NextState = BILL10;
                else if (twenty)
                    NextState = BILL20;
            end

            BILL10: begin
                bill = ON;
                if (ten)
                    NextState = BILL20;
                else if (twenty)
                    NextState = BILL30;
            end

            BILL20: begin
                bill = ON;
                if (ten)
                    NextState = BILL30;
                else if (twenty)
                    NextState = DISP;
            end

            BILL30: begin
                bill = ON;
                if (ten)
                    NextState = DISP;
                else if (twenty)
                    NextState = RTN;
            end

            DISP:   begin
                dispense = ON;
                NextState = RDY;
            end

            RTN:    begin
                return_sig = ON;
                NextState = RDY;
            end

            default: begin
                // Should not happen with proper state machine design, but good practice
                NextState = RDY;
            end
        endcase
    end

endmodule