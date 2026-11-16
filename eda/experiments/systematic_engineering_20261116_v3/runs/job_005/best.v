module pw_fast_add #(
    parameter WIDTH = 32,
    parameter SUB = 0
)(
    input wire [WIDTH-1:0] a, b,
    output wire [WIDTH-1:0] s
);
    localparam GROUPS = (WIDTH+3)/4;
    localparam LEVELS = $clog2(GROUPS);
    wire [WIDTH-1:0] bb, p, g;
    wire [GROUPS-1:0] gp [0:LEVELS];
    wire [GROUPS-1:0] gg [0:LEVELS];
    wire [GROUPS-1:0] block_c;
    assign bb = b ^ {WIDTH{SUB != 0}};
    assign p = a ^ bb;
    assign g = a & bb;

    genvar k, j, l, i, t;
    generate
        for (k = 0; k < GROUPS; k = k+1) begin: groups
            localparam LO = 4*k;
            localparam N = ((WIDTH-LO) >= 4) ? 4 : (WIDTH-LO);
            wire [N-1:0] terms;
            assign gp[0][k] = &p[LO+N-1:LO];
            for (j = 0; j < N; j = j+1) begin: group_terms
                if (j == N-1) begin: last_term
                    assign terms[j] = g[LO+j];
                end else begin: earlier_term
                    assign terms[j] = g[LO+j] & (&p[LO+N-1:LO+j+1]);
                end
            end
            assign gg[0][k] = |terms;
        end
        for (l = 0; l < LEVELS; l = l+1) begin: prefix_levels
            for (k = 0; k < GROUPS; k = k+1) begin: nodes
                if (k >= (1 << l)) begin: combine
                    assign gp[l+1][k] = gp[l][k] & gp[l][k-(1 << l)];
                    assign gg[l+1][k] = gg[l][k] | (gp[l][k] & gg[l][k-(1 << l)]);
                end else begin: pass_node
                    assign gp[l+1][k] = gp[l][k];
                    assign gg[l+1][k] = gg[l][k];
                end
            end
        end
        for (k = 0; k < GROUPS; k = k+1) begin: block_carries
            if (k == 0) begin: first
                assign block_c[k] = (SUB != 0);
            end else begin: subsequent
                assign block_c[k] = gg[LEVELS][k-1] | (gp[LEVELS][k-1] & (SUB != 0));
            end
        end
        for (i = 0; i < WIDTH; i = i+1) begin: sum_bits
            localparam LO = (i/4)*4;
            if (i == LO) begin: first_bit
                assign s[i] = p[i] ^ block_c[i/4];
            end else begin: other_bit
                wire [i-LO-1:0] terms;
                wire carry_in;
                for (t = LO; t < i; t = t+1) begin: carry_terms
                    if (t == i-1) begin: last_term
                        assign terms[t-LO] = g[t];
                    end else begin: earlier_term
                        assign terms[t-LO] = g[t] & (&p[i-1:t+1]);
                    end
                end
                assign carry_in = (|terms) | ((&p[i-1:LO]) & block_c[i/4]);
                assign s[i] = p[i] ^ carry_in;
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
    pw_fast_add #(.WIDTH(WIDTH), .SUB(0)) add_unit (
        .a(a), .b(b), .s(add_result)
    );
    pw_fast_add #(.WIDTH(WIDTH), .SUB(1)) ab_unit (
        .a(a), .b(b), .s(ab_result)
    );
    pw_fast_add #(.WIDTH(WIDTH), .SUB(1)) ba_unit (
        .a(b), .b(a), .s(ba_result)
    );
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
