module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    localparam LEVELS = $clog2(WIDTH);

    wire sub_a = (Oper == 3'b010);
    wire sub_b = (Oper == 3'b001);
    wire subtract = sub_a | sub_b;
    wire arithmetic_enable = ~Oper[2] & ~(Oper[1] & Oper[0]);
    wire or_enable   = (Oper == 3'b011);
    wire and_enable  = (Oper == 3'b100);
    wire xor_enable  = (Oper == 3'b101);
    wire xnor_enable = (Oper == 3'b110);

    wire [WIDTH-1:0] x = a ^ {WIDTH{sub_a}};
    wire [WIDTH-1:0] y = b ^ {WIDTH{sub_b}};
    wire [WIDTH-1:0] propagate [0:LEVELS];
    wire [WIDTH-1:0] generate_carry [0:LEVELS];
    wire [WIDTH:0] carry;
    wire [WIDTH-1:0] arithmetic_result;

    assign propagate[0] = x ^ y;
    assign generate_carry[0] = x & y;

    genvar level, bit_index;
    generate
        for (level = 0; level < LEVELS; level = level + 1) begin : prefix_level
            for (bit_index = 0; bit_index < WIDTH; bit_index = bit_index + 1) begin : prefix_bit
                if (bit_index >= (1 << level)) begin : combine
                    assign generate_carry[level+1][bit_index] =
                        generate_carry[level][bit_index] |
                        (propagate[level][bit_index] &
                         generate_carry[level][bit_index-(1 << level)]);
                    assign propagate[level+1][bit_index] =
                        propagate[level][bit_index] &
                        propagate[level][bit_index-(1 << level)];
                end else begin : forward
                    assign generate_carry[level+1][bit_index] =
                        generate_carry[level][bit_index];
                    assign propagate[level+1][bit_index] =
                        propagate[level][bit_index];
                end
            end
        end
    endgenerate

    assign carry[0] = subtract;
    generate
        for (bit_index = 0; bit_index < WIDTH; bit_index = bit_index + 1) begin : result_bit
            assign carry[bit_index+1] = generate_carry[LEVELS][bit_index] |
                (propagate[LEVELS][bit_index] & subtract);
            assign arithmetic_result[bit_index] = propagate[0][bit_index] ^ carry[bit_index];
        end
    endgenerate

    always @* begin
        sum = (arithmetic_result & {WIDTH{arithmetic_enable}}) |
              ((a | b)  & {WIDTH{or_enable}}) |
              ((a & b)  & {WIDTH{and_enable}}) |
              ((a ^ b)  & {WIDTH{xor_enable}}) |
              ((a ~^ b) & {WIDTH{xnor_enable}});
    end
endmodule
