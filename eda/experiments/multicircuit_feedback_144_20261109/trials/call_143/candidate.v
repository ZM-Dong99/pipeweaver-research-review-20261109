module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire subtracting = Oper[0] | Oper[1];
    wire arithmetic_enable = ~Oper[2] & ~(Oper[1] & Oper[0]);
    wire select_or   = ~Oper[2] &  Oper[1] &  Oper[0];
    wire select_and  =  Oper[2] & ~Oper[1] & ~Oper[0];
    wire select_xor  =  Oper[2] & ~Oper[1] &  Oper[0];
    wire select_xnor =  Oper[2] &  Oper[1] & ~Oper[0];

    wire [63:0] axb = a ^ b;
    wire [63:0] aandb = a & b;
    wire [63:0] operand_a = a ^ {64{Oper[1]}};
    wire [63:0] operand_b = b ^ {64{Oper[0]}};
    wire [63:0] bit_p = axb ^ {64{subtracting}};
    wire [63:0] bit_g = operand_a & operand_b;

    wire [63:0] prefix_p [0:6];
    wire [63:0] prefix_g [0:6];
    assign prefix_p[0] = bit_p;
    assign prefix_g[0] = {bit_g[63:1],
                         (bit_g[0] | (bit_p[0] & subtracting))};

    genvar level, bit_index;
    generate
        for (level = 0; level < 6; level = level + 1) begin : prefix_level
            for (bit_index = 0; bit_index < 64; bit_index = bit_index + 1) begin : prefix_bit
                if (bit_index >= (1 << level)) begin : combine
                    assign prefix_g[level+1][bit_index] =
                        prefix_g[level][bit_index] |
                        (prefix_p[level][bit_index] &
                         prefix_g[level][bit_index-(1 << level)]);
                    assign prefix_p[level+1][bit_index] =
                        prefix_p[level][bit_index] &
                        prefix_p[level][bit_index-(1 << level)];
                end else begin : pass_through
                    assign prefix_g[level+1][bit_index] = prefix_g[level][bit_index];
                    assign prefix_p[level+1][bit_index] = prefix_p[level][bit_index];
                end
            end
        end
    endgenerate

    wire [63:0] carry_in = {prefix_g[6][62:0], subtracting};
    wire [63:0] arithmetic_result = bit_p ^ carry_in;
    wire [63:0] logic_result =
        (aandb & {64{select_or | select_and}}) |
        (axb & {64{select_or | select_xor}}) |
        (~axb & {64{select_xnor}});

    always @(*) begin
        sum = (arithmetic_result & {64{arithmetic_enable}}) | logic_result;
    end
endmodule
