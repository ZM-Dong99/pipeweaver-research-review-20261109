module pw_alu_fast_add4 #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] x, y,
    input wire cin,
    output wire [WIDTH-1:0] s
);
    localparam BLOCKS = (WIDTH + 3) / 4;
    localparam LEVELS = $clog2(BLOCKS);
    wire [4*BLOCKS-1:0] p, g;
    wire [BLOCKS-1:0] gp [0:LEVELS];
    wire [BLOCKS-1:0] gg [0:LEVELS];
    wire [BLOCKS-1:0] bc;

    genvar i, j, k;
    generate
        for (i = 0; i < 4*BLOCKS; i = i+1) begin: bit_terms
            if (i < WIDTH) begin: real_bit
                assign p[i] = x[i] ^ y[i];
                assign g[i] = x[i] & y[i];
            end else begin: padding
                assign p[i] = 1'b1;
                assign g[i] = 1'b0;
            end
        end
        for (j = 0; j < BLOCKS; j = j+1) begin: block_terms
            assign gp[0][j] = p[4*j+3] & p[4*j+2] & p[4*j+1] & p[4*j];
            assign gg[0][j] = g[4*j+3]
                | (p[4*j+3] & g[4*j+2])
                | (p[4*j+3] & p[4*j+2] & g[4*j+1])
                | (p[4*j+3] & p[4*j+2] & p[4*j+1] & g[4*j]);
        end
        for (k = 0; k < LEVELS; k = k+1) begin: prefix_level
            for (j = 0; j < BLOCKS; j = j+1) begin: prefix_node
                if (j >= (1 << k)) begin: combine
                    assign gp[k+1][j] = gp[k][j] & gp[k][j-(1 << k)];
                    assign gg[k+1][j] = gg[k][j]
                        | (gp[k][j] & gg[k][j-(1 << k)]);
                end else begin: pass
                    assign gp[k+1][j] = gp[k][j];
                    assign gg[k+1][j] = gg[k][j];
                end
            end
        end
        for (j = 0; j < BLOCKS; j = j+1) begin: block_carry
            if (j == 0) begin: first
                assign bc[j] = cin;
            end else begin: later
                assign bc[j] = gg[LEVELS][j-1] | (gp[LEVELS][j-1] & cin);
            end
        end
        for (i = 0; i < WIDTH; i = i+1) begin: sum_bits
            wire c;
            if ((i % 4) == 0) begin: offset0
                assign c = bc[i/4];
            end else if ((i % 4) == 1) begin: offset1
                assign c = g[i-1] | (p[i-1] & bc[i/4]);
            end else if ((i % 4) == 2) begin: offset2
                assign c = g[i-1] | (p[i-1] & g[i-2])
                    | (p[i-1] & p[i-2] & bc[i/4]);
            end else begin: offset3
                assign c = g[i-1] | (p[i-1] & g[i-2])
                    | (p[i-1] & p[i-2] & g[i-3])
                    | (p[i-1] & p[i-2] & p[i-3] & bc[i/4]);
            end
            assign s[i] = p[i] ^ c;
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
    pw_alu_fast_add4 #(.WIDTH(WIDTH)) add_path (
        .x(a), .y(b), .cin(1'b0), .s(add_result)
    );
    pw_alu_fast_add4 #(.WIDTH(WIDTH)) sub_ab_path (
        .x(a), .y(~b), .cin(1'b1), .s(sub_ab_result)
    );
    pw_alu_fast_add4 #(.WIDTH(WIDTH)) sub_ba_path (
        .x(b), .y(~a), .cin(1'b1), .s(sub_ba_result)
    );
    always @* begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = sub_ab_result;
            3'b010: sum = sub_ba_result;
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
