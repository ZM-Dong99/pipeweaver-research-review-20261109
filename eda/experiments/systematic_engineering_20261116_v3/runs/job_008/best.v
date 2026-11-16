module pw_fast_add #(
    parameter WIDTH = 32,
    parameter SUBTRACT = 0
)(
    input wire [WIDTH-1:0] a, b,
    output wire [WIDTH-1:0] s
);
    localparam BLOCKS = (WIDTH+3)/4;
    localparam PAD_WIDTH = BLOCKS*4;
    localparam LEVELS = $clog2(BLOCKS);
    wire [PAD_WIDTH-1:0] p, g;
    wire [BLOCKS-1:0] bp [0:LEVELS];
    wire [BLOCKS-1:0] bg [0:LEVELS];
    wire [BLOCKS:0] carry;
    assign carry[0] = (SUBTRACT != 0);
    genvar i, j, l;
    generate
        for (i=0; i<PAD_WIDTH; i=i+1) begin: bit_terms
            if (i < WIDTH) begin: real_bit
                wire y;
                assign y = b[i] ^ (SUBTRACT != 0);
                assign p[i] = a[i] ^ y;
                assign g[i] = a[i] & y;
            end else begin: padding
                assign p[i] = 1'b1;
                assign g[i] = 1'b0;
            end
        end
        for (j=0; j<BLOCKS; j=j+1) begin: blocks
            assign bp[0][j] = &p[4*j +: 4];
            assign bg[0][j] = g[4*j+3] |
                (p[4*j+3] & g[4*j+2]) |
                (p[4*j+3] & p[4*j+2] & g[4*j+1]) |
                (p[4*j+3] & p[4*j+2] & p[4*j+1] & g[4*j]);
            assign carry[j+1] = bg[LEVELS][j] |
                (bp[LEVELS][j] & (SUBTRACT != 0));
            for (i=0; i<4; i=i+1) begin: sum_bits
                if (4*j+i < WIDTH) begin: real_sum
                    wire c;
                    if (i == 0) begin: c0
                        assign c = carry[j];
                    end else if (i == 1) begin: c1
                        assign c = g[4*j] | (p[4*j] & carry[j]);
                    end else if (i == 2) begin: c2
                        assign c = g[4*j+1] | (p[4*j+1] & g[4*j]) |
                            (p[4*j+1] & p[4*j] & carry[j]);
                    end else begin: c3
                        assign c = g[4*j+2] | (p[4*j+2] & g[4*j+1]) |
                            (p[4*j+2] & p[4*j+1] & g[4*j]) |
                            (p[4*j+2] & p[4*j+1] & p[4*j] & carry[j]);
                    end
                    assign s[4*j+i] = p[4*j+i] ^ c;
                end
            end
        end
        for (l=0; l<LEVELS; l=l+1) begin: prefix_levels
            for (j=0; j<BLOCKS; j=j+1) begin: prefix_blocks
                if (j >= (1 << l)) begin: combine
                    assign bg[l+1][j] = bg[l][j] |
                        (bp[l][j] & bg[l][j-(1 << l)]);
                    assign bp[l+1][j] = bp[l][j] & bp[l][j-(1 << l)];
                end else begin: pass
                    assign bg[l+1][j] = bg[l][j];
                    assign bp[l+1][j] = bp[l][j];
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
    wire [WIDTH-1:0] add_result, ab_result, ba_result;
    pw_fast_add #(.WIDTH(WIDTH), .SUBTRACT(0)) add_unit
        (.a(a), .b(b), .s(add_result));
    pw_fast_add #(.WIDTH(WIDTH), .SUBTRACT(1)) ab_unit
        (.a(a), .b(b), .s(ab_result));
    pw_fast_add #(.WIDTH(WIDTH), .SUBTRACT(1)) ba_unit
        (.a(b), .b(a), .s(ba_result));
    always @* begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = ab_result;
            3'b010: sum = ba_result;
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
