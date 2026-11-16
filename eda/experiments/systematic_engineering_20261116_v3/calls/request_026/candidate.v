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

wire sel_read  = (state == S_READ);
wire sel_proc1 = (state == S_PROC1);
wire sel_proc2 = (state == S_PROC2);
wire sel_proc3 = (state == S_PROC3);
wire sel_done  = (state == S_DONE);
wire sel_error = (state == S_ERROR);
wire sel_pass = sel_read | sel_done;

wire [7:0] increment_carry;
wire [7:0] incremented;
wire [7:0] shifted;
assign increment_carry[0] = 1'b1;
genvar k;
generate
    for (k = 1; k < 8; k = k + 1) begin : gen_increment_prefix
        assign increment_carry[k] = &data_in[k-1:0];
    end
endgenerate
assign incremented = data_in ^ increment_carry;
assign shifted = {data_in[6:0], 1'b0};

always @(*) begin
    data_out = ({8{sel_pass}}  & data_in)
             | ({8{sel_proc1}} & incremented)
             | ({8{sel_proc2}} & shifted)
             | ({8{sel_proc3}} & ~data_in)
             | ({8{sel_error}} & 8'hEE);
    done = sel_done;
end

always @(posedge clk) begin
    if (rst)
        state <= S_IDLE;
    else
        state <= next_state;
end

endmodule
