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
wire read_match;
wire error_clear;
wire [7:0] incremented;
wire [7:0] shifted;

assign read_match = data_in[3] & ~data_in[2] & data_in[1];
assign error_clear = &data_in[2:0];
assign incremented = data_in + 8'h01;
assign shifted = data_in << 1;

always @(*) begin
    next_state[0] = (state[0] & ~start) | state[7] |
                    (state[8] & error_clear);
    next_state[1] = state[0] & start;
    next_state[2] = (state[1] & data_in[0]) |
                    (state[6] & data_in[4]);
    next_state[3] = state[2] & read_match;
    next_state[4] = state[3];
    next_state[5] = state[4] & data_in[7];
    next_state[6] = (state[2] & ~read_match) |
                    (state[4] & ~data_in[7]) |
                    (state[6] & ~data_in[4]);
    next_state[7] = state[5];
    next_state[8] = (state[1] & ~data_in[0]) |
                    (state[8] & ~error_clear);
end

always @(*) begin
    data_out = ({8{state[2] | state[7]}} & data_in) |
               ({8{state[3]}} & incremented) |
               ({8{state[4]}} & shifted) |
               ({8{state[5]}} & ~data_in) |
               ({8{state[8]}} & 8'hEE);
    done = state[7];
end

always @(posedge clk) begin
    if (rst)
        state <= S_IDLE;
    else
        state <= next_state;
end

endmodule
