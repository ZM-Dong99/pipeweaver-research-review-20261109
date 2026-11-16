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

wire idle_s  = (state == S_IDLE);
wire start_s = (state == S_START);
wire read_s  = (state == S_READ);
wire proc1_s = (state == S_PROC1);
wire proc2_s = (state == S_PROC2);
wire proc3_s = (state == S_PROC3);
wire wait_s  = (state == S_WAIT);
wire done_s  = (state == S_DONE);
wire error_s = (state == S_ERROR);
wire valid_s = idle_s | start_s | read_s | proc1_s | proc2_s |
               proc3_s | wait_s | done_s | error_s;
wire read_match = data_in[3] & ~data_in[2] & data_in[1];
wire error_exit = &data_in[2:0];

always @(*) begin
    next_state = 9'b000000000;
    next_state[0] = ~valid_s | (idle_s & ~start) | done_s |
                    (error_s & error_exit);
    next_state[1] = idle_s & start;
    next_state[2] = (start_s & data_in[0]) | (wait_s & data_in[4]);
    next_state[3] = read_s & read_match;
    next_state[4] = proc1_s;
    next_state[5] = proc2_s & data_in[7];
    next_state[6] = (read_s & ~read_match) |
                    (proc2_s & ~data_in[7]) |
                    (wait_s & ~data_in[4]);
    next_state[7] = proc3_s;
    next_state[8] = (start_s & ~data_in[0]) |
                    (error_s & ~error_exit);
end

wire [7:0] incremented;
assign incremented[0] = ~data_in[0];
assign incremented[1] = data_in[1] ^ data_in[0];
assign incremented[2] = data_in[2] ^ (&data_in[1:0]);
assign incremented[3] = data_in[3] ^ (&data_in[2:0]);
assign incremented[4] = data_in[4] ^ (&data_in[3:0]);
assign incremented[5] = data_in[5] ^ (&data_in[4:0]);
assign incremented[6] = data_in[6] ^ (&data_in[5:0]);
assign incremented[7] = data_in[7] ^ (&data_in[6:0]);

wire pass_s = read_s | done_s;
always @(*) begin
    data_out = ({8{pass_s}} & data_in) |
               ({8{proc1_s}} & incremented) |
               ({8{proc2_s}} & {data_in[6:0], 1'b0}) |
               ({8{proc3_s}} & ~data_in) |
               ({8{error_s}} & 8'hEE);
    done = done_s;
end

always @(posedge clk) begin
    if (rst)
        state <= S_IDLE;
    else
        state <= next_state;
end

endmodule
