module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);
    wire [15:0] row [0:7];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: partial_rows
            assign row[i] = ({8'b0, (multiplier & {8{multiplicand[i]}})} << i);
        end
    endgenerate

    wire [15:0] s0, c0, s1, c1;
    wire [15:0] s2, c2, s3, c3;
    wire [15:0] s4, c4, s5, c5;

    assign s0 = row[0] ^ row[1] ^ row[2];
    assign c0 = ((row[0] & row[1]) | (row[0] & row[2]) | (row[1] & row[2])) << 1;
    assign s1 = row[3] ^ row[4] ^ row[5];
    assign c1 = ((row[3] & row[4]) | (row[3] & row[5]) | (row[4] & row[5])) << 1;

    assign s2 = s0 ^ c0 ^ s1;
    assign c2 = ((s0 & c0) | (s0 & s1) | (c0 & s1)) << 1;
    assign s3 = c1 ^ row[6] ^ row[7];
    assign c3 = ((c1 & row[6]) | (c1 & row[7]) | (row[6] & row[7])) << 1;

    assign s4 = s2 ^ c2 ^ s3;
    assign c4 = ((s2 & c2) | (s2 & s3) | (c2 & s3)) << 1;
    assign s5 = s4 ^ c4 ^ c3;
    assign c5 = ((s4 & c4) | (s4 & c3) | (c4 & c3)) << 1;

    wire [15:0] propagate [0:4];
    wire [15:0] generate_carry [0:4];
    assign propagate[0] = s5 ^ c5;
    assign generate_carry[0] = s5 & c5;

    genvar level, bit_index;
    generate
        for (level = 0; level < 4; level = level + 1) begin: prefix_level
            for (bit_index = 0; bit_index < 16; bit_index = bit_index + 1) begin: prefix_bit
                if ((bit_index % (2 << level)) >= (1 << level)) begin: combine
                    localparam integer BASE = (bit_index / (2 << level)) * (2 << level) + (1 << level) - 1;
                    assign generate_carry[level+1][bit_index] = generate_carry[level][bit_index] |
                        (propagate[level][bit_index] & generate_carry[level][BASE]);
                    assign propagate[level+1][bit_index] = propagate[level][bit_index] & propagate[level][BASE];
                end else begin: forward
                    assign generate_carry[level+1][bit_index] = generate_carry[level][bit_index];
                    assign propagate[level+1][bit_index] = propagate[level][bit_index];
                end
            end
        end
    endgenerate

    assign product = propagate[0] ^ {generate_carry[4][14:0], 1'b0};
endmodule
