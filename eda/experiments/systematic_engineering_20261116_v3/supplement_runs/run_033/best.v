module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    localparam LEVELS = (WIDTH > 1) ? $clog2(WIDTH) : 0;
    wire negate_a = (Oper == 3'b010);
    wire negate_b = (Oper == 3'b001);
    wire carry_in = negate_a | negate_b;
    wire [WIDTH-1:0] x = a ^ {WIDTH{negate_a}};
    wire [WIDTH-1:0] y = b ^ {WIDTH{negate_b}};
    wire [WIDTH-1:0] bit_propagate = x ^ y;
    wire [WIDTH-1:0] prefix_p [0:LEVELS];
    wire [WIDTH-1:0] prefix_g [0:LEVELS];
    wire [WIDTH-1:0] arithmetic_result;

    assign prefix_p[0] = bit_propagate;
    assign prefix_g[0][0] = (x[0] & y[0]) |
                                      (bit_propagate[0] & carry_in);
    genvar bit_index, level, column;
    generate
        for (bit_index = 1; bit_index < WIDTH; bit_index = bit_index + 1) begin: initial_generate
            assign prefix_g[0][bit_index] = x[bit_index] & y[bit_index];
        end
        for (level = 0; level < LEVELS; level = level + 1) begin: prefix_level
            for (column = 0; column < WIDTH; column = column + 1) begin: prefix_column
                if (column >= (1 << level)) begin: combine
                    assign prefix_g[level+1][column] =
                        prefix_g[level][column] |
                        (prefix_p[level][column] &
                         prefix_g[level][column-(1 << level)]);
                    assign prefix_p[level+1][column] =
                        prefix_p[level][column] &
                        prefix_p[level][column-(1 << level)];
                end else begin: pass_through
                    assign prefix_g[level+1][column] = prefix_g[level][column];
                    assign prefix_p[level+1][column] = prefix_p[level][column];
                end
            end
        end
        for (bit_index = 0; bit_index < WIDTH; bit_index = bit_index + 1) begin: result_bits
            if (bit_index == 0) begin: low_bit
                assign arithmetic_result[bit_index] = bit_propagate[bit_index] ^ carry_in;
            end else begin: upper_bit
                assign arithmetic_result[bit_index] =
                    bit_propagate[bit_index] ^ prefix_g[LEVELS][bit_index-1];
            end
        end
    endgenerate

    always @* begin
        case (Oper)
            3'b000: sum = arithmetic_result;
            3'b001: sum = arithmetic_result;
            3'b010: sum = arithmetic_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = {WIDTH{1'b0}};
        endcase
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
