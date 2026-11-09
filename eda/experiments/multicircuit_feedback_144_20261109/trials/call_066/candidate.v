module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire sub_mode = Oper[0] | Oper[1];
    wire [63:0] base_xor = a ^ b;
    wire [63:0] ax = a ^ {64{Oper[1]}};
    wire [63:0] bx = b ^ {64{Oper[0]}};
    wire [63:0] bit_p = base_xor ^ {64{sub_mode}};
    wire [63:0] bit_g = ax & bx;

    wire [63:0] pp [0:6];
    wire [63:0] gg [0:6];
    assign pp[0] = bit_p;
    assign gg[0][0] = bit_g[0] | (bit_p[0] & sub_mode);
    assign gg[0][63:1] = bit_g[63:1];

    genvar level, bit_index;
    generate
        for (level = 0; level < 6; level = level + 1) begin : prefix_level
            for (bit_index = 0; bit_index < 64; bit_index = bit_index + 1) begin : prefix_bit
                if (bit_index >= (1 << level)) begin : combine
                    assign pp[level+1][bit_index] =
                        pp[level][bit_index] & pp[level][bit_index-(1 << level)];
                    assign gg[level+1][bit_index] =
                        gg[level][bit_index] |
                        (pp[level][bit_index] & gg[level][bit_index-(1 << level)]);
                end else begin : forward
                    assign pp[level+1][bit_index] = pp[level][bit_index];
                    assign gg[level+1][bit_index] = gg[level][bit_index];
                end
            end
        end
    endgenerate

    wire [63:0] arithmetic_result;
    assign arithmetic_result[0] = bit_p[0] ^ sub_mode;
    assign arithmetic_result[63:1] = bit_p[63:1] ^ gg[6][62:0];

    wire select_arithmetic = ~Oper[2] & ~(Oper[1] & Oper[0]);
    wire select_or   = (Oper == 3'b011);
    wire select_and  = (Oper == 3'b100);
    wire select_xor  = (Oper == 3'b101);
    wire select_xnor = (Oper == 3'b110);

    always @* begin
        sum = (arithmetic_result & {64{select_arithmetic}})
            | ((a | b) & {64{select_or}})
            | ((a & b) & {64{select_and}})
            | (base_xor & {64{select_xor}})
            | (~base_xor & {64{select_xnor}});
    end
endmodule
