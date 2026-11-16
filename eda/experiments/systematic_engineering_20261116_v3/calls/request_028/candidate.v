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

(* fsm_encoding = "none" *) reg [8:0] state;
reg [8:0] next_state;

wire idle_sel  = (state == S_IDLE);
wire start_sel = (state == S_START);
wire read_sel  = (state == S_READ);
wire proc1_sel = (state == S_PROC1);
wire proc2_sel = (state == S_PROC2);
wire proc3_sel = (state == S_PROC3);
wire wait_sel  = (state == S_WAIT);
wire done_sel  = (state == S_DONE);
wire error_sel = (state == S_ERROR);

wire read_match = (data_in[3:1] == 3'b101);
wire error_exit = &data_in[2:0];
wire [7:0] incremented = data_in + 8'h01;
wire pass_sel = read_sel | done_sel;

always @(*) begin
    next_state = 9'b0;
    next_state[1] = idle_sel & start;
    next_state[2] = (start_sel & data_in[0]) |
                    (wait_sel & data_in[4]);
    next_state[3] = read_sel & read_match;
    next_state[4] = proc1_sel;
    next_state[5] = proc2_sel & data_in[7];
    next_state[6] = (read_sel & ~read_match) |
                    (proc2_sel & ~data_in[7]) |
                    (wait_sel & ~data_in[4]);
    next_state[7] = proc3_sel;
    next_state[8] = (start_sel & ~data_in[0]) |
                    (error_sel & ~error_exit);
    next_state[0] = ~(|next_state[8:1]);
end

always @(*) begin
    data_out = ({8{pass_sel}} & data_in) |
               ({8{proc1_sel}} & incremented) |
               ({8{proc2_sel}} & {data_in[6:0], 1'b0}) |
               ({8{proc3_sel}} & ~data_in) |
               ({8{error_sel}} & 8'hEE);
    done = done_sel;
end

always @(posedge clk) begin
    if (rst)
        state <= S_IDLE;
    else
        state <= next_state;
end

endmodule
