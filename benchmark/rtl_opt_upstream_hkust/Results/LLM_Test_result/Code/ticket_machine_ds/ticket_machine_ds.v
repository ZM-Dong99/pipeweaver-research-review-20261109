module ticket_machine_ds #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    localparam [2:0] RDY    = 3'd0,
                     BILL10 = 3'd1,
                     BILL20 = 3'd2,
                     BILL30 = 3'd3,
                     DISP   = 3'd4,
                     RTN    = 3'd5;

    reg [2:0] State, NextState;

    always @(posedge clk) begin 
        State <= clear ? RDY : NextState;
    end

    always @(State) begin
        {ready, bill, dispense, return_sig} = 4'b0000;
        case (State)
            RDY:    ready = ON;
            DISP:   dispense = ON;
            RTN:    return_sig = ON;
            BILL10,
            BILL20,
            BILL30: bill = ON;
        endcase
    end

    always @(*) begin
        NextState = State;
        case (State)
            RDY:    if (ten)       NextState = BILL10;
                    else if (twenty) NextState = BILL20;
            BILL10: if (ten)       NextState = BILL20;
                    else if (twenty) NextState = BILL30;
            BILL20: if (ten)       NextState = BILL30;
                    else if (twenty) NextState = DISP;
            BILL30: if (ten)       NextState = DISP;
                    else if (twenty) NextState = RTN;
            DISP,
            RTN:    NextState = RDY;
        endcase
    end

endmodule