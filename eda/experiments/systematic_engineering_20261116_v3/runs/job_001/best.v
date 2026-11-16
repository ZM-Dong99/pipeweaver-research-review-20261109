module pw_alu_cla #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire cin,
    output wire [WIDTH-1:0] sum
);
    localparam BLOCKS = (WIDTH + 3) / 4;
    localparam LEVELS = $clog2(BLOCKS);
    localparam PAD = 4 * BLOCKS;
    wire [PAD-1:0] p, g;
    wire [BLOCKS-1:0] gp [0:LEVELS];
    wire [BLOCKS-1:0] gg [0:LEVELS];
    wire [BLOCKS:0] bc;
    wire [PAD-1:0] full_sum;
    genvar i, k, l;
    generate
        for (i = 0; i < PAD; i = i+1) begin: bits_pg
            if (i < WIDTH) begin: real_bit
                assign p[i] = a[i] ^ b[i];
                assign g[i] = a[i] & b[i];
            end else begin: padding
                assign p[i] = 1'b1;
                assign g[i] = 1'b0;
            end
        end
        for (k = 0; k < BLOCKS; k = k+1) begin: blocks
            wire [4:0] c;
            assign gp[0][k] = p[4*k+3] & p[4*k+2] & p[4*k+1] & p[4*k];
            assign gg[0][k] = g[4*k+3]
                | (p[4*k+3] & g[4*k+2])
                | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
            assign c[0] = bc[k];
            assign c[1] = g[4*k] | (p[4*k] & c[0]);
            assign c[2] = g[4*k+1] | (p[4*k+1] & g[4*k])
                | (p[4*k+1] & p[4*k] & c[0]);
            assign c[3] = g[4*k+2] | (p[4*k+2] & g[4*k+1])
                | (p[4*k+2] & p[4*k+1] & g[4*k])
                | (p[4*k+2] & p[4*k+1] & p[4*k] & c[0]);
            assign c[4] = gg[0][k] | (gp[0][k] & c[0]);
            assign full_sum[4*k +: 4] = p[4*k +: 4] ^ c[3:0];
        end
        for (l = 0; l < LEVELS; l = l+1) begin: prefix_levels
            for (k = 0; k < BLOCKS; k = k+1) begin: prefix_blocks
                if (k >= (1 << l)) begin: combine
                    assign gp[l+1][k] = gp[l][k] & gp[l][k-(1 << l)];
                    assign gg[l+1][k] = gg[l][k]
                        | (gp[l][k] & gg[l][k-(1 << l)]);
                end else begin: pass_through
                    assign gp[l+1][k] = gp[l][k];
                    assign gg[l+1][k] = gg[l][k];
                end
            end
        end
        for (k = 0; k < BLOCKS; k = k+1) begin: block_carries
            assign bc[k+1] = gg[LEVELS][k] | (gp[LEVELS][k] & cin);
        end
    endgenerate
    assign bc[0] = cin;
    assign sum = full_sum[WIDTH-1:0];
endmodule

module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] add_result, sub_ab, sub_ba;
    wire [WIDTH-1:0] bit_or, bit_and, bit_xor, bit_xnor;
    wire [6:0] select_op;
    pw_alu_cla #(.WIDTH(WIDTH)) add_unit (
        .a(a), .b(b), .cin(1'b0), .sum(add_result)
    );
    pw_alu_cla #(.WIDTH(WIDTH)) sub_ab_unit (
        .a(a), .b(~b), .cin(1'b1), .sum(sub_ab)
    );
    pw_alu_cla #(.WIDTH(WIDTH)) sub_ba_unit (
        .a(b), .b(~a), .cin(1'b1), .sum(sub_ba)
    );
    assign bit_or = a | b;
    assign bit_and = a & b;
    assign bit_xor = a ^ b;
    assign bit_xnor = a ~^ b;
    assign select_op[0] = (Oper == 3'b000);
    assign select_op[1] = (Oper == 3'b001);
    assign select_op[2] = (Oper == 3'b010);
    assign select_op[3] = (Oper == 3'b011);
    assign select_op[4] = (Oper == 3'b100);
    assign select_op[5] = (Oper == 3'b101);
    assign select_op[6] = (Oper == 3'b110);
    always @* begin
        sum = ({WIDTH{select_op[0]}} & add_result)
            | ({WIDTH{select_op[1]}} & sub_ab)
            | ({WIDTH{select_op[2]}} & sub_ba)
            | ({WIDTH{select_op[3]}} & bit_or)
            | ({WIDTH{select_op[4]}} & bit_and)
            | ({WIDTH{select_op[5]}} & bit_xor)
            | ({WIDTH{select_op[6]}} & bit_xnor);
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
