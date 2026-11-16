module pw_alu_prefix_add #(
    parameter WIDTH = 64,
    parameter SUB = 0
)(
    input wire [WIDTH-1:0] x, y,
    output wire [WIDTH-1:0] z
);
    localparam LEVELS = (WIDTH > 1) ? $clog2(WIDTH) : 0;
    wire [WIDTH-1:0] yy;
    wire [WIDTH-1:0] bit_p;
    wire [WIDTH-1:0] group_p [0:LEVELS];
    wire [WIDTH-1:0] group_g [0:LEVELS];

    assign yy = SUB ? ~y : y;
    assign bit_p = x ^ yy;
    assign group_p[0] = bit_p;
    assign group_g[0] = x & yy;

    genvar level, bit_index;
    generate
        for (level = 0; level < LEVELS; level = level + 1) begin: prefix_level
            for (bit_index = 0; bit_index < WIDTH; bit_index = bit_index + 1) begin: prefix_bit
                if (bit_index >= (1 << level)) begin: combine
                    assign group_p[level+1][bit_index] =
                        group_p[level][bit_index] & group_p[level][bit_index-(1 << level)];
                    assign group_g[level+1][bit_index] =
                        group_g[level][bit_index] |
                        (group_p[level][bit_index] & group_g[level][bit_index-(1 << level)]);
                end else begin: pass_through
                    assign group_p[level+1][bit_index] = group_p[level][bit_index];
                    assign group_g[level+1][bit_index] = group_g[level][bit_index];
                end
            end
        end
        for (bit_index = 0; bit_index < WIDTH; bit_index = bit_index + 1) begin: sum_bit
            if (bit_index == 0) begin: first_bit
                assign z[bit_index] = bit_p[bit_index] ^ (SUB != 0);
            end else if (SUB != 0) begin: subtract_bit
                assign z[bit_index] = bit_p[bit_index] ^
                    (group_g[LEVELS][bit_index-1] | group_p[LEVELS][bit_index-1]);
            end else begin: add_bit
                assign z[bit_index] = bit_p[bit_index] ^ group_g[LEVELS][bit_index-1];
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
    wire [WIDTH-1:0] add_result, sub_ab_result, sub_ba_result;
    wire [WIDTH-1:0] xor_result;
    wire select_add, select_sub_ab, select_sub_ba;
    wire select_or, select_and, select_xor, select_xnor;

    pw_alu_prefix_add #(.WIDTH(WIDTH), .SUB(0)) add_unit (
        .x(a), .y(b), .z(add_result)
    );
    pw_alu_prefix_add #(.WIDTH(WIDTH), .SUB(1)) sub_ab_unit (
        .x(a), .y(b), .z(sub_ab_result)
    );
    pw_alu_prefix_add #(.WIDTH(WIDTH), .SUB(1)) sub_ba_unit (
        .x(b), .y(a), .z(sub_ba_result)
    );

    assign xor_result = a ^ b;
    assign select_add = (Oper == 3'b000);
    assign select_sub_ab = (Oper == 3'b001);
    assign select_sub_ba = (Oper == 3'b010);
    assign select_or = (Oper == 3'b011);
    assign select_and = (Oper == 3'b100);
    assign select_xor = (Oper == 3'b101);
    assign select_xnor = (Oper == 3'b110);

    always @* begin
        sum = ({WIDTH{select_add}} & add_result) |
              ({WIDTH{select_sub_ab}} & sub_ab_result) |
              ({WIDTH{select_sub_ba}} & sub_ba_result) |
              ({WIDTH{select_or}} & (a | b)) |
              ({WIDTH{select_and}} & (a & b)) |
              ({WIDTH{select_xor}} & xor_result) |
              ({WIDTH{select_xnor}} & ~xor_result);
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
        for (index = 0; index < STAGES-1; index = index+1) begin: output_pipeline
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
