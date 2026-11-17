module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    localparam LEVELS = $clog2(WIDTH);

    wire [WIDTH-1:0] axb;
    wire [WIDTH-1:0] add_a, add_b;
    wire [WIDTH-1:0] bit_p;
    wire [WIDTH-1:0] pg [0:LEVELS];
    wire [WIDTH-1:0] gg [0:LEVELS];
    wire [WIDTH-1:0] carry;
    wire [WIDTH-1:0] arithmetic_result;
    wire cin;
    wire inversion_parity;
    wire arithmetic_enable;
    wire or_enable, and_enable, xor_enable;
    wire [WIDTH-1:0] xor_result;

    assign axb = a ^ b;
    assign add_a = a ^ {WIDTH{Oper[1]}};
    assign add_b = b ^ {WIDTH{Oper[0]}};
    assign inversion_parity = Oper[1] ^ Oper[0];
    assign bit_p = axb ^ {WIDTH{inversion_parity}};
    assign cin = Oper[1] | Oper[0];

    assign pg[0] = bit_p;
    assign gg[0][0] = (add_a[0] & add_b[0]) | (bit_p[0] & cin);

    genvar i, s;
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : initial_generate
            assign gg[0][i] = add_a[i] & add_b[i];
        end
        for (s = 0; s < LEVELS; s = s + 1) begin : prefix_stage
            for (i = 0; i < WIDTH; i = i + 1) begin : prefix_bit
                if (i >= (1 << s)) begin : combine
                    assign gg[s+1][i] = gg[s][i] |
                        (pg[s][i] & gg[s][i-(1 << s)]);
                    assign pg[s+1][i] = pg[s][i] & pg[s][i-(1 << s)];
                end else begin : pass_through
                    assign gg[s+1][i] = gg[s][i];
                    assign pg[s+1][i] = pg[s][i];
                end
            end
        end
        for (i = 0; i < WIDTH; i = i + 1) begin : result_bit
            if (i == 0) begin : first_bit
                assign carry[i] = cin;
            end else begin : remaining_bits
                assign carry[i] = gg[LEVELS][i-1];
            end
        end
    endgenerate

    assign arithmetic_result = bit_p ^ carry;
    assign arithmetic_enable = ~Oper[2] & ~(Oper[1] & Oper[0]);
    assign or_enable = (Oper == 3'b011);
    assign and_enable = (Oper == 3'b100);
    assign xor_enable = (Oper == 3'b101) | (Oper == 3'b110);
    assign xor_result = axb ^ {WIDTH{Oper[1]}};

    always @* begin
        sum = (arithmetic_result & {WIDTH{arithmetic_enable}})
            | ((a | b) & {WIDTH{or_enable}})
            | ((a & b) & {WIDTH{and_enable}})
            | (xor_result & {WIDTH{xor_enable}});
    end
endmodule
