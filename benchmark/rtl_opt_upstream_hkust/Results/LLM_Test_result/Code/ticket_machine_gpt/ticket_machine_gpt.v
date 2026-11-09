module ticket_machine_gpt #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    // Use one-hot encoding to define states
    localparam RDY    = 6'b000001,
               DISP   = 6'b000010,
               RTN    = 6'b000100,
               BILL10 = 6'b001000,
               BILL20 = 6'b010000,
               BILL30 = 6'b100000;

    reg [5:0] State, NextState;

    // Update state on clock rising edge
    always @(posedge clk or posedge clear) begin 
        if (clear)
            State <= RDY;
        else
            State <= NextState;
    end

    // Output logic based on current state (Moore state machine)
    always @(*) begin
        {ready, dispense, return_sig, bill} = 4'b0000; // Default values
        case (State)
            RDY:   ready = ON;
            DISP:  dispense = ON;
            RTN:   return_sig = ON;
            default: bill = ON; // Covers BILL10, BILL20, BILL30
        endcase
    end

    // Next state logic
    always @(*) begin
        case (State)
            RDY:   NextState = (ten ? BILL10 : (twenty ? BILL20 : RDY));
            BILL10: NextState = (ten ? BILL20 : (twenty ? BILL30 : BILL10));
            BILL20: NextState = (ten ? BILL30 : (twenty ? DISP : BILL20));
            BILL30: NextState = (ten ? DISP : (twenty ? RTN : BILL30));
            DISP:  NextState = RDY;
            RTN:   NextState = RDY;
            default: NextState = RDY;
        endcase
    end

endmodule