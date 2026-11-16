module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    localparam LEVELS = $clog2(WIDTH);
    wire [WIDTH-1:0] ax, bx;
    wire [WIDTH-1:0] bit_p;
    wire [WIDTH-1:0] arithmetic_result;
    wire [WIDTH-1:0] prefix_p [0:LEVELS];
    wire [WIDTH-1:0] prefix_g [0:LEVELS];
    wire carry_in;
    wire arithmetic_enable, or_enable, and_enable;
    wire xor_enable, xnor_enable;

    // For the three arithmetic opcodes these implement, respectively,
    // a+b, a+(~b)+1, and (~a)+b+1.
    assign ax = a ^ {WIDTH{Oper[1]}};
    assign bx = b ^ {WIDTH{Oper[0]}};
    assign carry_in = Oper[0] | Oper[1];
    assign bit_p = ax ^ bx;
    assign prefix_p[0] = bit_p;

    genvar i, level;
    generate
        for (i = 0; i < WIDTH; i = i+1) begin: initial_generate
            if (i == 0) begin: low_bit
                assign prefix_g[0][i] = (ax[i] & bx[i]) |
                                             (bit_p[i] & carry_in);
            end else begin: other_bit
                assign prefix_g[0][i] = ax[i] & bx[i];
            end
        end
        for (level = 0; level < LEVELS; level = level+1) begin: carry_prefix
            for (i = 0; i < WIDTH; i = i+1) begin: bit_prefix
                if (i >= (1 << level)) begin: combine
                    assign prefix_g[level+1][i] = prefix_g[level][i] |
                        (prefix_p[level][i] & prefix_g[level][i-(1 << level)]);
                    assign prefix_p[level+1][i] = prefix_p[level][i] &
                                                 prefix_p[level][i-(1 << level)];
                end else begin: pass_through
                    assign prefix_g[level+1][i] = prefix_g[level][i];
                    assign prefix_p[level+1][i] = prefix_p[level][i];
                end
            end
        end
        for (i = 0; i < WIDTH; i = i+1) begin: sum_bits
            if (i == 0) begin: low_bit
                assign arithmetic_result[i] = bit_p[i] ^ carry_in;
            end else begin: other_bit
                assign arithmetic_result[i] = bit_p[i] ^ prefix_g[LEVELS][i-1];
            end
        end
    endgenerate

    assign arithmetic_enable = (Oper == 3'b000) |
                               (Oper == 3'b001) |
                               (Oper == 3'b010);
    assign or_enable = (Oper == 3'b011);
    assign and_enable = (Oper == 3'b100);
    assign xor_enable = (Oper == 3'b101);
    assign xnor_enable = (Oper == 3'b110);

    always @* begin
        sum = (arithmetic_result & {WIDTH{arithmetic_enable}}) |
              ((a | b) & {WIDTH{or_enable}}) |
              ((a & b) & {WIDTH{and_enable}}) |
              ((a ^ b) & {WIDTH{xor_enable}}) |
              ((a ~^ b) & {WIDTH{xnor_enable}});
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
