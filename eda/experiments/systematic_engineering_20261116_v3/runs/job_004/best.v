module pw_alu_carry4 #(
    parameter WIDTH = 64,
    parameter SUB = 0
)(
    input wire [WIDTH-1:0] a, b,
    output wire [WIDTH-1:0] y
);
    localparam GROUPS = (WIDTH+3)/4;
    localparam PAD = GROUPS*4;
    localparam LEVELS = $clog2(GROUPS);
    wire [PAD-1:0] p, g;
    wire [GROUPS-1:0] gp [0:LEVELS];
    wire [GROUPS-1:0] gg [0:LEVELS];
    wire [GROUPS:0] carry;
    genvar i, k, l;
    generate
        for (i=0; i<PAD; i=i+1) begin: bits_pg
            if (i<WIDTH) begin: real_bit
                wire bx;
                assign bx = b[i] ^ (SUB != 0);
                assign p[i] = a[i] ^ bx;
                assign g[i] = a[i] & bx;
            end else begin: padding
                assign p[i] = 1'b1;
                assign g[i] = 1'b0;
            end
        end
        for (k=0; k<GROUPS; k=k+1) begin: groups
            assign gp[0][k] = p[4*k+3] & p[4*k+2] & p[4*k+1] & p[4*k];
            assign gg[0][k] = g[4*k+3]
                | (p[4*k+3] & g[4*k+2])
                | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
        end
        for (l=0; l<LEVELS; l=l+1) begin: prefix_level
            for (k=0; k<GROUPS; k=k+1) begin: prefix_group
                if (k >= (1 << l)) begin: combine
                    assign gp[l+1][k] = gp[l][k] & gp[l][k-(1 << l)];
                    assign gg[l+1][k] = gg[l][k] | (gp[l][k] & gg[l][k-(1 << l)]);
                end else begin: pass
                    assign gp[l+1][k] = gp[l][k];
                    assign gg[l+1][k] = gg[l][k];
                end
            end
        end
    endgenerate
    assign carry[0] = (SUB != 0);
    generate
        for (k=0; k<GROUPS; k=k+1) begin: local_sum
            wire [3:0] c;
            assign carry[k+1] = gg[LEVELS][k] | (gp[LEVELS][k] & (SUB != 0));
            assign c[0] = carry[k];
            assign c[1] = g[4*k] | (p[4*k] & carry[k]);
            assign c[2] = g[4*k+1] | (p[4*k+1] & g[4*k])
                | (p[4*k+1] & p[4*k] & carry[k]);
            assign c[3] = g[4*k+2] | (p[4*k+2] & g[4*k+1])
                | (p[4*k+2] & p[4*k+1] & g[4*k])
                | (p[4*k+2] & p[4*k+1] & p[4*k] & carry[k]);
            for (i=0; i<4; i=i+1) begin: sum_bit
                if ((4*k+i)<WIDTH) begin: real_bit
                    assign y[4*k+i] = p[4*k+i] ^ c[i];
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
    wire [6:0] select_op;
    pw_alu_carry4 #(.WIDTH(WIDTH), .SUB(0)) add_unit (.a(a), .b(b), .y(add_result));
    pw_alu_carry4 #(.WIDTH(WIDTH), .SUB(1)) ab_unit (.a(a), .b(b), .y(ab_result));
    pw_alu_carry4 #(.WIDTH(WIDTH), .SUB(1)) ba_unit (.a(b), .b(a), .y(ba_result));
    assign select_op[0] = (Oper == 3'b000);
    assign select_op[1] = (Oper == 3'b001);
    assign select_op[2] = (Oper == 3'b010);
    assign select_op[3] = (Oper == 3'b011);
    assign select_op[4] = (Oper == 3'b100);
    assign select_op[5] = (Oper == 3'b101);
    assign select_op[6] = (Oper == 3'b110);
    always @* begin
        sum = ({WIDTH{select_op[0]}} & add_result)
            | ({WIDTH{select_op[1]}} & ab_result)
            | ({WIDTH{select_op[2]}} & ba_result)
            | ({WIDTH{select_op[3]}} & (a | b))
            | ({WIDTH{select_op[4]}} & (a & b))
            | ({WIDTH{select_op[5]}} & (a ^ b))
            | ({WIDTH{select_op[6]}} & (a ~^ b));
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
