module pw_block_prefix_add #(
    parameter WIDTH = 32
)(
    input wire [WIDTH-1:0] x, y,
    input wire cin,
    output wire [WIDTH-1:0] s
);
    localparam BLOCKS = (WIDTH + 3) / 4;
    localparam PAD = BLOCKS * 4;
    localparam LEVELS = $clog2(BLOCKS);
    wire [PAD-1:0] p, g;
    wire [BLOCKS-1:0] bp [0:LEVELS];
    wire [BLOCKS-1:0] bg [0:LEVELS];
    wire [BLOCKS:0] bc;
    wire [PAD-1:0] full_sum;
    assign bc[0] = cin;
    genvar i, k, l;
    generate
        for (i = 0; i < PAD; i = i + 1) begin: bit_terms
            if (i < WIDTH) begin: real_bit
                assign p[i] = x[i] ^ y[i];
                assign g[i] = x[i] & y[i];
            end else begin: padding
                assign p[i] = 1'b1;
                assign g[i] = 1'b0;
            end
        end
        for (k = 0; k < BLOCKS; k = k + 1) begin: block_terms
            assign bp[0][k] = p[4*k+3] & p[4*k+2] & p[4*k+1] & p[4*k];
            assign bg[0][k] = g[4*k+3]
                | (p[4*k+3] & g[4*k+2])
                | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
        end
        for (l = 0; l < LEVELS; l = l + 1) begin: prefix_level
            for (k = 0; k < BLOCKS; k = k + 1) begin: prefix_node
                if (k >= (1 << l)) begin: combine
                    assign bg[l+1][k] = bg[l][k] | (bp[l][k] & bg[l][k-(1 << l)]);
                    assign bp[l+1][k] = bp[l][k] & bp[l][k-(1 << l)];
                end else begin: forward
                    assign bg[l+1][k] = bg[l][k];
                    assign bp[l+1][k] = bp[l][k];
                end
            end
        end
        for (k = 0; k < BLOCKS; k = k + 1) begin: block_sum
            wire c1, c2, c3;
            assign bc[k+1] = bg[LEVELS][k] | (bp[LEVELS][k] & cin);
            assign c1 = g[4*k] | (p[4*k] & bc[k]);
            assign c2 = g[4*k+1] | (p[4*k+1] & g[4*k])
                | (p[4*k+1] & p[4*k] & bc[k]);
            assign c3 = g[4*k+2] | (p[4*k+2] & g[4*k+1])
                | (p[4*k+2] & p[4*k+1] & g[4*k])
                | (p[4*k+2] & p[4*k+1] & p[4*k] & bc[k]);
            assign full_sum[4*k] = p[4*k] ^ bc[k];
            assign full_sum[4*k+1] = p[4*k+1] ^ c1;
            assign full_sum[4*k+2] = p[4*k+2] ^ c2;
            assign full_sum[4*k+3] = p[4*k+3] ^ c3;
        end
    endgenerate
    assign s = full_sum[WIDTH-1:0];
endmodule

module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire invert_a = (Oper == 3'b010);
    wire invert_b = (Oper == 3'b001);
    wire [WIDTH-1:0] arithmetic_x = a ^ {WIDTH{invert_a}};
    wire [WIDTH-1:0] arithmetic_y = b ^ {WIDTH{invert_b}};
    wire [WIDTH-1:0] arithmetic_sum;
    pw_block_prefix_add #(.WIDTH(WIDTH)) arithmetic (
        .x(arithmetic_x), .y(arithmetic_y),
        .cin(invert_a | invert_b), .s(arithmetic_sum)
    );
    always @* begin
        case (Oper)
            3'b000, 3'b001, 3'b010: sum = arithmetic_sum;
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
