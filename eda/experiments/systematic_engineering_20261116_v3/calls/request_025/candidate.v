module pw_fsm_sync (
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);

localparam [8:0] S_IDLE  = 9'b000000001;
localparam [8:0] S_START = 9'b000000010;
localparam [8:0] S_READ  = 9'b000000100;
localparam [8:0] S_PROC1 = 9'b000001000;
localparam [8:0] S_PROC2 = 9'b000010000;
localparam [8:0] S_PROC3 = 9'b000100000;
localparam [8:0] S_WAIT  = 9'b001000000;
localparam [8:0] S_DONE  = 9'b010000000;
localparam [8:0] S_ERROR = 9'b100000000;

reg [8:0] state, next_state;

always @(*) begin
    next_state = S_IDLE;
    case (state)
        S_IDLE:  next_state = start ? S_START : S_IDLE;
        S_START: next_state = data_in[0] ? S_READ : S_ERROR;
        S_READ:  next_state = (data_in[3:1] == 3'b101) ? S_PROC1 : S_WAIT;
        S_PROC1: next_state = S_PROC2;
        S_PROC2: next_state = data_in[7] ? S_PROC3 : S_WAIT;
        S_PROC3: next_state = S_DONE;
        S_WAIT:  next_state = data_in[4] ? S_READ : S_WAIT;
        S_DONE:  next_state = S_IDLE;
        S_ERROR: next_state = (data_in[2:0] == 3'b111) ? S_IDLE : S_ERROR;
        default: next_state = S_IDLE;
    endcase
end

wire read_sel;
wire proc1_sel;
wire proc2_sel;
wire proc3_sel;
wire done_sel;
wire error_sel;
wire pass_sel;
wire [7:0] incremented;

assign read_sel  = (state == S_READ);
assign proc1_sel = (state == S_PROC1);
assign proc2_sel = (state == S_PROC2);
assign proc3_sel = (state == S_PROC3);
assign done_sel  = (state == S_DONE);
assign error_sel = (state == S_ERROR);
assign pass_sel  = read_sel | done_sel;

// Explicit parallel carry predicates for the modulo-256 increment.
assign incremented[0] = ~data_in[0];
assign incremented[1] = data_in[1] ^ data_in[0];
assign incremented[2] = data_in[2] ^ (&data_in[1:0]);
assign incremented[3] = data_in[3] ^ (&data_in[2:0]);
assign incremented[4] = data_in[4] ^ (&data_in[3:0]);
assign incremented[5] = data_in[5] ^ (&data_in[4:0]);
assign incremented[6] = data_in[6] ^ (&data_in[5:0]);
assign incremented[7] = data_in[7] ^ (&data_in[6:0]);

always @(*) begin
    data_out = ({8{pass_sel}} & data_in)
             | ({8{proc1_sel}} & incremented)
             | ({8{proc2_sel}} & {data_in[6:0], 1'b0})
             | ({8{proc3_sel}} & ~data_in)
             | ({8{error_sel}} & 8'hEE);
    done = done_sel;
end

always @(posedge clk) begin
    if (rst)
        state <= S_IDLE;
    else
        state <= next_state;
end

endmodule
