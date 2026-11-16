module pw_alu_prefix_carry #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] p,
    input wire [WIDTH-1:0] g,
    output wire [WIDTH-1:0] carry
);
    localparam LEVELS = (WIDTH > 1) ? $clog2(WIDTH) : 0;
    wire [WIDTH-1:0] pp [0:LEVELS];
    wire [WIDTH-1:0] gg [0:LEVELS];
    assign pp[0] = p;
    assign gg[0] = g;
    genvar level, bit_index;
    generate
        for (level = 0; level < LEVELS; level = level + 1) begin: prefix_level
            localparam integer DIST = (1 << level);
            for (bit_index = 0; bit_index < WIDTH; bit_index = bit_index + 1) begin: prefix_bit
                if ((bit_index % (2*DIST)) >= DIST) begin: combine
                    localparam integer ANCHOR = (bit_index / (2*DIST)) * (2*DIST) + DIST - 1;
                    assign pp[level+1][bit_index] = pp[level][bit_index] & pp[level][ANCHOR];
                    assign gg[level+1][bit_index] = gg[level][bit_index] |
                        (pp[level][bit_index] & gg[level][ANCHOR]);
                end else begin: forward
                    assign pp[level+1][bit_index] = pp[level][bit_index];
                    assign gg[level+1][bit_index] = gg[level][bit_index];
                end
            end
        end
        for (bit_index = 0; bit_index < WIDTH; bit_index = bit_index + 1) begin: carry_output
            if (bit_index == 0) begin: first_bit
                assign carry[bit_index] = 1'b0;
            end else begin: other_bit
                assign carry[bit_index] = gg[LEVELS][bit_index-1];
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
    wire [WIDTH-1:0] bit_xor = a ^ b;
    wire [WIDTH-1:0] bit_equal = ~bit_xor;
    wire [WIDTH-1:0] bit_and = a & b;
    wire [WIDTH-1:0] bit_or = a | b;
    wire [WIDTH-1:0] add_carry, ab_borrow, ba_borrow;
    wire [WIDTH-1:0] add_value = bit_xor ^ add_carry;
    wire [WIDTH-1:0] ab_value = bit_xor ^ ab_borrow;
    wire [WIDTH-1:0] ba_value = bit_xor ^ ba_borrow;

    pw_alu_prefix_carry #(.WIDTH(WIDTH)) add_prefix (
        .p(bit_xor), .g(bit_and), .carry(add_carry)
    );
    pw_alu_prefix_carry #(.WIDTH(WIDTH)) ab_prefix (
        .p(bit_equal), .g((~a) & b), .carry(ab_borrow)
    );
    pw_alu_prefix_carry #(.WIDTH(WIDTH)) ba_prefix (
        .p(bit_equal), .g(a & (~b)), .carry(ba_borrow)
    );

    wire select_add = (Oper == 3'b000);
    wire select_ab = (Oper == 3'b001);
    wire select_ba = (Oper == 3'b010);
    wire select_or = (Oper == 3'b011);
    wire select_and = (Oper == 3'b100);
    wire select_xor = (Oper == 3'b101);
    wire select_xnor = (Oper == 3'b110);

    always @* begin
        sum = ({WIDTH{select_add}} & add_value) |
              ({WIDTH{select_ab}} & ab_value) |
              ({WIDTH{select_ba}} & ba_value) |
              ({WIDTH{select_or}} & bit_or) |
              ({WIDTH{select_and}} & bit_and) |
              ({WIDTH{select_xor}} & bit_xor) |
              ({WIDTH{select_xnor}} & bit_equal);
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
