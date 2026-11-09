module ticket_machine_dsr #(
    parameter ON  = 1'b1,
    parameter OFF = 1'b0
) (
    input  clk, clear, ten, twenty,
    output reg ready, dispense, return_sig, bill
);

    localparam RDY    = 3'b000,
               DISP   = 3'b001,
               RTN    = 3'b010,
               BILL10 = 3'b011,
               BILL20 = 3'b100,
               BILL30 = 3'b101;

    reg [2:0] State, NextState;

    always @(posedge clk) begin
        State <= clear ? RDY : NextState;
    end

    always @* begin
        {ready, bill, dispense, return_sig} = 4'b0000;
        case (State)
            RDY:    ready = ON;
            DISP:   dispense = ON;
            RTN:    return_sig = ON;
            BILL10, BILL20, BILL30: bill = ON;
        endcase
    end

    always @* begin
        NextState = State;
        case (State)
            RDY: begin
                if (ten)        NextState = BILL10;
                else if (twenty)NextState = BILL20;
            end
            BILL10: begin
                if (ten)        NextState = BILL20;
                else if (twenty)NextState = BILL30;
            end
            BILL20: begin
                if (ten)        NextState = BILL30;
                else if (twenty)NextState = DISP;
            end
            BILL30: begin
                if (ten)        NextState = DISP;
                else if (twenty)NextState = RTN;
            end
            DISP, RTN:          NextState = RDY;
        endcase
    end

endmodule