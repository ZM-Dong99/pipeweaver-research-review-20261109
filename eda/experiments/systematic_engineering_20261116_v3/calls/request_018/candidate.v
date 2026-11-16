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

wire select_read = (state == S_READ);
wire select_proc1 = (state == S_PROC1);
wire select_proc2 = (state == S_PROC2);
wire select_proc3 = (state == S_PROC3);
wire select_done = (state == S_DONE);
wire select_error = (state == S_ERROR);
wire select_pass = select_read | select_done;

// Increment carries are independent prefix reductions, not a ripple chain.
wire [7:0] incremented;
assign incremented[0] = ~data_in[0];
assign incremented[1] = data_in[1] ^ data_in[0];
assign incremented[2] = data_in[2] ^ (&data_in[1:0]);
assign incremented[3] = data_in[3] ^ (&data_in[2:0]);
assign incremented[4] = data_in[4] ^ (&data_in[3:0]);
assign incremented[5] = data_in[5] ^ (&data_in[4:0]);
assign incremented[6] = data_in[6] ^ (&data_in[5:0]);
assign incremented[7] = data_in[7] ^ (&data_in[6:0]);

always @(*) begin
    data_out = ({8{select_pass}} & data_in)
             | ({8{select_proc1}} & incremented)
             | ({8{select_proc2}} & {data_in[6:0], 1'b0})
             | ({8{select_proc3}} & ~data_in)
             | ({8{select_error}} & 8'hEE);
    done = select_done;
end

always @(posedge clk) begin
    if (rst)
        state <= S_IDLE;
    else
        state <= next_state;
end

endmodule
