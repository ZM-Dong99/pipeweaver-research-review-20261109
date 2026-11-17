module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    localparam integer GROUPS = (WIDTH + 3) / 4;
    localparam integer PAD_WIDTH = 4 * GROUPS;
    localparam integer LEVELS = $clog2(GROUPS);

    wire negate_a = (Oper == 3'b010);
    wire negate_b = (Oper == 3'b001);
    wire carry_in = negate_a | negate_b;
    wire [WIDTH-1:0] operand_a;
    wire [WIDTH-1:0] operand_b;
    wire [PAD_WIDTH-1:0] bit_p;
    wire [PAD_WIDTH-1:0] bit_g;
    wire [GROUPS-1:0] prefix_p [0:LEVELS];
    wire [GROUPS-1:0] prefix_g [0:LEVELS];
    wire [GROUPS:0] block_carry;
    wire [WIDTH-1:0] arithmetic_result;

    assign operand_a = a ^ {WIDTH{negate_a}};
    assign operand_b = b ^ {WIDTH{negate_b}};
    assign bit_p[WIDTH-1:0] = operand_a ^ operand_b;
    assign bit_g[WIDTH-1:0] = operand_a & operand_b;

    generate
        if (PAD_WIDTH > WIDTH) begin : padding
            assign bit_p[PAD_WIDTH-1:WIDTH] = {(PAD_WIDTH-WIDTH){1'b1}};
            assign bit_g[PAD_WIDTH-1:WIDTH] = {(PAD_WIDTH-WIDTH){1'b0}};
        end
    endgenerate

    genvar j, s, k;
    generate
        for (j = 0; j < GROUPS; j = j + 1) begin : group_terms
            assign prefix_p[0][j] = &bit_p[4*j +: 4];
            assign prefix_g[0][j] = bit_g[4*j+3]
                | (bit_p[4*j+3] & bit_g[4*j+2])
                | (bit_p[4*j+3] & bit_p[4*j+2] & bit_g[4*j+1])
                | (bit_p[4*j+3] & bit_p[4*j+2] & bit_p[4*j+1] & bit_g[4*j]);
        end
        for (s = 0; s < LEVELS; s = s + 1) begin : prefix_levels
            for (j = 0; j < GROUPS; j = j + 1) begin : prefix_nodes
                if (j >= (1 << s)) begin : combine
                    assign prefix_g[s+1][j] = prefix_g[s][j]
                        | (prefix_p[s][j] & prefix_g[s][j-(1 << s)]);
                    assign prefix_p[s+1][j] = prefix_p[s][j]
                        & prefix_p[s][j-(1 << s)];
                end else begin : pass_through
                    assign prefix_g[s+1][j] = prefix_g[s][j];
                    assign prefix_p[s+1][j] = prefix_p[s][j];
                end
            end
        end
    endgenerate

    assign block_carry[0] = carry_in;
    generate
        for (j = 0; j < GROUPS; j = j + 1) begin : carry_and_sum
            wire [3:0] local_carry;
            assign block_carry[j+1] = prefix_g[LEVELS][j]
                | (prefix_p[LEVELS][j] & carry_in);
            assign local_carry[0] = block_carry[j];
            assign local_carry[1] = bit_g[4*j]
                | (bit_p[4*j] & block_carry[j]);
            assign local_carry[2] = bit_g[4*j+1]
                | (bit_p[4*j+1] & bit_g[4*j])
                | (bit_p[4*j+1] & bit_p[4*j] & block_carry[j]);
            assign local_carry[3] = bit_g[4*j+2]
                | (bit_p[4*j+2] & bit_g[4*j+1])
                | (bit_p[4*j+2] & bit_p[4*j+1] & bit_g[4*j])
                | (bit_p[4*j+2] & bit_p[4*j+1] & bit_p[4*j] & block_carry[j]);
            for (k = 0; k < 4; k = k + 1) begin : result_bits
                if ((4*j+k) < WIDTH) begin : valid_bit
                    assign arithmetic_result[4*j+k] = bit_p[4*j+k] ^ local_carry[k];
                end
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
