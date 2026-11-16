module pw_alu_fast_add #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] x, y,
    input wire cin,
    output wire [WIDTH-1:0] z
);
    localparam GROUPS = (WIDTH+3)/4;
    localparam LEVELS = (GROUPS > 1) ? $clog2(GROUPS) : 0;
    wire [4*GROUPS-1:0] p, g;
    wire [GROUPS-1:0] gp [0:LEVELS];
    wire [GROUPS-1:0] gg [0:LEVELS];
    wire [GROUPS:0] carry;
    assign carry[0] = cin;
    genvar i, j, k;
    generate
        for (i=0; i<4*GROUPS; i=i+1) begin: bit_pg
            if (i < WIDTH) begin: real_bit
                assign p[i] = x[i] ^ y[i];
                assign g[i] = x[i] & y[i];
            end else begin: padding
                assign p[i] = 1'b1;
                assign g[i] = 1'b0;
            end
        end
        for (j=0; j<GROUPS; j=j+1) begin: blocks
            wire [3:0] bp, bg;
            wire [3:0] bc;
            assign bp = p[4*j +: 4];
            assign bg = g[4*j +: 4];
            assign gp[0][j] = &bp;
            assign gg[0][j] = bg[3] | (bp[3]&bg[2]) |
                (bp[3]&bp[2]&bg[1]) |
                (bp[3]&bp[2]&bp[1]&bg[0]);
            assign carry[j+1] = gg[LEVELS][j] |
                (gp[LEVELS][j] & cin);
            assign bc[0] = carry[j];
            assign bc[1] = bg[0] | (bp[0]&carry[j]);
            assign bc[2] = bg[1] | (bp[1]&bg[0]) |
                (bp[1]&bp[0]&carry[j]);
            assign bc[3] = bg[2] | (bp[2]&bg[1]) |
                (bp[2]&bp[1]&bg[0]) |
                (bp[2]&bp[1]&bp[0]&carry[j]);
            for (k=0; k<4; k=k+1) begin: sum_bits
                if (4*j+k < WIDTH) begin: real_sum
                    assign z[4*j+k] = bp[k] ^ bc[k];
                end
            end
        end
        for (i=0; i<LEVELS; i=i+1) begin: prefix_level
            for (j=0; j<GROUPS; j=j+1) begin: prefix_node
                if (j >= (1<<i)) begin: combine
                    assign gp[i+1][j] = gp[i][j] & gp[i][j-(1<<i)];
                    assign gg[i+1][j] = gg[i][j] |
                        (gp[i][j] & gg[i][j-(1<<i)]);
                end else begin: pass_through
                    assign gp[i+1][j] = gp[i][j];
                    assign gg[i+1][j] = gg[i][j];
                end
            end
        end
    endgenerate
endmodule

module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] add_result, sub_ab, sub_ba;
    wire [6:0] select_op;
    pw_alu_fast_add #(.WIDTH(WIDTH)) add_unit (
        .x(a), .y(b), .cin(1'b0), .z(add_result)
    );
    pw_alu_fast_add #(.WIDTH(WIDTH)) sub_ab_unit (
        .x(a), .y(~b), .cin(1'b1), .z(sub_ab)
    );
    pw_alu_fast_add #(.WIDTH(WIDTH)) sub_ba_unit (
        .x(b), .y(~a), .cin(1'b1), .z(sub_ba)
    );
    assign select_op[0] = (Oper == 3'b000);
    assign select_op[1] = (Oper == 3'b001);
    assign select_op[2] = (Oper == 3'b010);
    assign select_op[3] = (Oper == 3'b011);
    assign select_op[4] = (Oper == 3'b100);
    assign select_op[5] = (Oper == 3'b101);
    assign select_op[6] = (Oper == 3'b110);
    always @* begin
        sum = ({WIDTH{select_op[0]}} & add_result) |
              ({WIDTH{select_op[1]}} & sub_ab) |
              ({WIDTH{select_op[2]}} & sub_ba) |
              ({WIDTH{select_op[3]}} & (a | b)) |
              ({WIDTH{select_op[4]}} & (a & b)) |
              ({WIDTH{select_op[5]}} & (a ^ b)) |
              ({WIDTH{select_op[6]}} & (a ~^ b));
    end
endmodule

module pw_pipeline_alu #(
    parameter WIDTH = 32,
    parameter STAGES = 2
)(
    input wire clk, rst,
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    input wire in_valid,
    output wire [WIDTH-1:0] result,
    output wire out_valid
);
    reg [WIDTH-1:0] operand_a, operand_b;
    reg [2:0] opcode;
    reg input_valid;
    wire [WIDTH-1:0] alu_result;
    wire [WIDTH-1:0] stage_data [0:STAGES-2];
    wire stage_valid [0:STAGES-2];

    always @(posedge clk) begin
        if (rst) begin
            operand_a <= 0;
            operand_b <= 0;
            opcode <= 0;
            input_valid <= 0;
        end else begin
            operand_a <= a;
            operand_b <= b;
            opcode <= Oper;
            input_valid <= in_valid;
        end
    end

    pw_alu #(.WIDTH(WIDTH)) alu (
        .a(operand_a), .b(operand_b), .Oper(opcode), .sum(alu_result)
    );

    genvar index;
    generate
        for (index=0; index<STAGES-1; index=index+1) begin: output_pipeline
            reg [WIDTH-1:0] data_reg;
            reg valid_reg;
            wire [WIDTH-1:0] next_data;
            wire next_valid;
            if (index == 0) begin: first_stage
                assign next_data = alu_result;
                assign next_valid = input_valid;
            end else begin: following_stage
                assign next_data = stage_data[index-1];
                assign next_valid = stage_valid[index-1];
            end
            always @(posedge clk) begin
                if (rst) begin
                    data_reg <= 0;
                    valid_reg <= 0;
                end else begin
                    data_reg <= next_data;
                    valid_reg <= next_valid;
                end
            end
            assign stage_data[index] = data_reg;
            assign stage_valid[index] = valid_reg;
        end
    endgenerate
    assign result = stage_data[STAGES-2];
    assign out_valid = stage_valid[STAGES-2];
endmodule
