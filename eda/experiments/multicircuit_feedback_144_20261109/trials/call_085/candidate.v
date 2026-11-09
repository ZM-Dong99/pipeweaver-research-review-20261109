module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire sub_mode = Oper[0] | Oper[1];
    wire reverse_sub = Oper[1];
    wire arithmetic_enable = (Oper == 3'b000) | (Oper == 3'b001) | (Oper == 3'b010);
    wire or_enable = (Oper == 3'b011);
    wire and_enable = (Oper == 3'b100);
    wire xor_enable = (Oper == 3'b101);
    wire xnor_enable = (Oper == 3'b110);

    wire [63:0] bit_xor = a ^ b;
    wire [63:0] bit_prop = bit_xor ^ {64{sub_mode}};
    wire [63:0] bit_gen = reverse_sub
        ? (b & ~a)
        : (a & (b ^ {64{sub_mode}}));

    wire [63:0] prefix_p [0:6];
    wire [63:0] prefix_g [0:6];
    assign prefix_p[0] = bit_prop;
    assign prefix_g[0][0] = bit_gen[0] | (bit_prop[0] & sub_mode);
    assign prefix_g[0][63:1] = bit_gen[63:1];

    genvar level, bit_index;
    generate
        for (level = 0; level < 6; level = level + 1) begin : prefix_levels
            for (bit_index = 0; bit_index < 64; bit_index = bit_index + 1) begin : prefix_bits
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

    wire [63:0] carry_in = {prefix_g[6][62:0], sub_mode};
    wire [63:0] arithmetic_result = bit_prop ^ carry_in;
    wire [63:0] logic_result =
        (bit_xor & {64{or_enable | xor_enable}}) |
        ((a & b) & {64{or_enable | and_enable}}) |
        (~bit_xor & {64{xnor_enable}});

    always @* begin
        sum = (arithmetic_result & {64{arithmetic_enable}}) | logic_result;
    end
endmodule
