module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire reverse_sub = (Oper == 3'b010);
    wire forward_sub = (Oper == 3'b001);
    wire subtract = reverse_sub | forward_sub;
    wire arithmetic_enable = (~Oper[2]) & (~(Oper[1] & Oper[0]));
    wire or_enable   = (Oper == 3'b011);
    wire and_enable  = (Oper == 3'b100);
    wire xor_enable = (Oper == 3'b101);
    wire xnor_enable = (Oper == 3'b110);

    wire [63:0] raw_xor = a ^ b;
    wire [63:0] x = a ^ {64{reverse_sub}};
    wire [63:0] y = b ^ {64{forward_sub}};
    wire [63:0] propagate = raw_xor ^ {64{subtract}};
    wire [63:0] generate_bits = x & y;
    wire [63:0] p [0:6];
    wire [63:0] g [0:6];
    wire [63:0] arithmetic_result;
    wire [63:0] logic_result;

    assign p[0] = propagate;
    assign g[0] = {generate_bits[63:1],
                   (generate_bits[0] | (propagate[0] & subtract))};

    genvar stage, bit_index;
    generate
        for (stage = 0; stage < 6; stage = stage + 1) begin: prefix_stage
            for (bit_index = 0; bit_index < 64; bit_index = bit_index + 1) begin: prefix_bit
                if (bit_index >= (1 << stage)) begin: combine
                    assign p[stage+1][bit_index] =
                        p[stage][bit_index] & p[stage][bit_index-(1 << stage)];
                    assign g[stage+1][bit_index] =
                        g[stage][bit_index] |
                        (p[stage][bit_index] & g[stage][bit_index-(1 << stage)]);
                end else begin: pass_through
                    assign p[stage+1][bit_index] = p[stage][bit_index];
                    assign g[stage+1][bit_index] = g[stage][bit_index];
                end
            end
        end
    endgenerate

    assign arithmetic_result[0] = raw_xor[0];
    assign arithmetic_result[63:1] = propagate[63:1] ^ g[6][62:0];
    assign logic_result =
        ((a | b) & {64{or_enable}}) |
        ((a & b) & {64{and_enable}}) |
        (raw_xor & {64{xor_enable}}) |
        ((~raw_xor) & {64{xnor_enable}});

    always @(*) begin
        sum = (arithmetic_result & {64{arithmetic_enable}}) | logic_result;
    end
endmodule
