module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    localparam LEVELS = $clog2(WIDTH);

    wire op_add = (Oper == 3'b000);
    wire op_ab  = (Oper == 3'b001);
    wire op_ba  = (Oper == 3'b010);
    wire op_or  = (Oper == 3'b011);
    wire op_and = (Oper == 3'b100);
    wire op_xor = (Oper == 3'b101);
    wire op_xnr = (Oper == 3'b110);
    wire arithmetic_enable = op_add | op_ab | op_ba;
    wire subtract_mode = op_ab | op_ba;

    wire [WIDTH-1:0] x = a ^ b;
    wire [WIDTH-1:0] adjusted_b = b ^ {WIDTH{subtract_mode}};
    wire [WIDTH-1:0] bit_p = x ^ {WIDTH{subtract_mode}};
    wire [WIDTH-1:0] bit_g = a & adjusted_b;
    wire [WIDTH-1:0] prefix_p [0:LEVELS];
    wire [WIDTH-1:0] prefix_g [0:LEVELS];
    wire [WIDTH-1:0] arithmetic_result;

    assign prefix_p[0] = bit_p;

    genvar i, level;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : initial_generate
            if (i == 0) begin : with_carry_in
                assign prefix_g[0][i] = bit_g[i] | (bit_p[i] & op_ab);
            end else begin : without_carry_in
                assign prefix_g[0][i] = bit_g[i];
            end
        end
        for (level = 0; level < LEVELS; level = level + 1) begin : prefix_level
            for (i = 0; i < WIDTH; i = i + 1) begin : prefix_bit
                if (i >= (1 << level)) begin : combine
                    assign prefix_g[level+1][i] =
                        prefix_g[level][i] |
                        (prefix_p[level][i] & prefix_g[level][i-(1 << level)]);
                    assign prefix_p[level+1][i] =
                        prefix_p[level][i] & prefix_p[level][i-(1 << level)];
                end else begin : forward
                    assign prefix_g[level+1][i] = prefix_g[level][i];
                    assign prefix_p[level+1][i] = prefix_p[level][i];
                end
            end
        end
        for (i = 0; i < WIDTH; i = i + 1) begin : result_bit
            if (i == 0) begin : low_bit
                assign arithmetic_result[i] = x[i];
            end else begin : upper_bit
                assign arithmetic_result[i] = x[i] ^ op_ab ^ prefix_g[LEVELS][i-1];
            end
        end
    endgenerate

    always @* begin
        sum = ({WIDTH{arithmetic_enable}} & arithmetic_result)
            | ({WIDTH{op_or}}  & (a | b))
            | ({WIDTH{op_and}} & (a & b))
            | ({WIDTH{op_xor}} & x)
            | ({WIDTH{op_xnr}} & ~x);
    end
endmodule
