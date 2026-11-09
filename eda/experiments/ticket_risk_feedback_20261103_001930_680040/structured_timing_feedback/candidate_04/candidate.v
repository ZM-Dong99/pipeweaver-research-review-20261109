module ticket_machine #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    localparam RDY    = 6'b000001,
               DISP   = 6'b000010,
               RTN    = 6'b000100,
               BILL10 = 6'b001000,
               BILL20 = 6'b010000,
               BILL30 = 6'b100000;

    reg [5:0] State, NextState;
    wire bill_next;

    // Determine whether the destination state is a bill state.
    // In particular, ten retains priority over twenty.
    assign bill_next = ((State == RDY) && (ten || twenty)) ||
                       (State == BILL10) ||
                       ((State == BILL20) && (ten || !twenty)) ||
                       ((State == BILL30) && !ten && !twenty);

    always @(posedge clk) begin
        if (clear) begin
            State <= RDY;
            bill <= OFF;
        end else begin
            State <= NextState;
            bill <= bill_next ? ON : OFF;
        end
    end

    always @* begin
        ready = OFF;
        dispense = OFF;
        return_sig = OFF;
        case (State)
            RDY: ready = ON;
            DISP: dispense = ON;
            RTN: return_sig = ON;
            default: begin
                ready = OFF;
                dispense = OFF;
                return_sig = OFF;
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
            DISP: NextState = RDY;
            RTN: NextState = RDY;
            default: NextState = RDY;
        endcase
    end
endmodule
