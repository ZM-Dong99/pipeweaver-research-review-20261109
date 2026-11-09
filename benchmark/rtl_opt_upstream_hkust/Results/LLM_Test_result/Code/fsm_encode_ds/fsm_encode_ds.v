module fsm_encode_ds (
    input clk,
    input rst_n,
    input start,
    input [7:0] data_in,
    output [7:0] data_out,
    output reg done
);

localparam
    IDLE    = 3'd0,
    LOAD1   = 3'd1,
    LOAD2   = 3'd2,
    ADD     = 3'd3,
    SUB     = 3'd4,
    SHIFT   = 3'd5,
    STORE1  = 3'd6,
    STORE2  = 3'd7;

reg [2:0] current_state, next_state;
reg [7:0] reg1, reg2;
reg [7:0] out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        reg1 <= 8'b0;
        reg2 <= 8'b0;
        out_reg <= 8'b0;
        done <= 1'b0;
    end else begin
        current_state <= next_state;
        case (next_state)
            LOAD1:  reg1 <= data_in;
            LOAD2:  reg2 <= data_in;
            ADD:    reg1 <= reg1 + reg2;
            SUB:    reg1 <= reg1 - reg2;
            SHIFT:  reg1 <= reg1 << 1;
            STORE1: out_reg <= reg1;
            STORE2: begin
                out_reg <= reg2;
                done <= 1'b1;
            end
            default: done <= 1'b0;
        endcase
    end
end

always @(*) begin
    case (current_state)
        IDLE:   next_state = start ? LOAD1 : IDLE;
        LOAD1:  next_state = LOAD2;
        LOAD2:  next_state = ADD;
        ADD:    next_state = SUB;
        SUB:    next_state = SHIFT;
        SHIFT:  next_state = STORE1;
        STORE1: next_state = STORE2;
        STORE2: next_state = IDLE;
        default:next_state = IDLE;
    endcase
end

assign data_out = out_reg;

endmodule