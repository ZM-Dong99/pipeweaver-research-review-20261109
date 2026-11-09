module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire do_add, do_ab, do_ba, do_or, do_and, do_xor, do_xnor;
    wire subtract;
    wire [63:0] x, y, p, g, bit_xor;
    wire [15:0] bp, bg;
    wire [15:0] p1, g1, p2, g2, p3, g3, p4, g4;
    wire [15:0] block_c;
    wire [63:0] carry, arithmetic_result, logic_result;
    wire arithmetic_enable;

    assign do_add  = (Oper == 3'b000);
    assign do_ab   = (Oper == 3'b001);
    assign do_ba   = (Oper == 3'b010);
    assign do_or   = (Oper == 3'b011);
    assign do_and  = (Oper == 3'b100);
    assign do_xor  = (Oper == 3'b101);
    assign do_xnor = (Oper == 3'b110);
    assign subtract = do_ab | do_ba;
    assign arithmetic_enable = do_add | subtract;

    // Both subtraction directions use the same carry network.
    assign x = a ^ {64{do_ba}};
    assign y = b ^ {64{do_ab}};
    assign p = x | y;
    assign g = x & y;
    assign bit_xor = (a ^ b) ^ {64{subtract}};

    // Four-bit group generate/propagate, followed by a balanced
    // sixteen-group parallel-prefix network.
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : groups
            assign bp[k] = &p[4*k +: 4];
            assign bg[k] = g[4*k+3]
                         | (p[4*k+3] & g[4*k+2])
                         | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                         | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
        end
        for (k = 0; k < 16; k = k + 1) begin : prefix
            if (k >= 1) begin : s1
                assign p1[k] = bp[k] & bp[k-1];
                assign g1[k] = bg[k] | (bp[k] & bg[k-1]);
            end else begin : s1_pass
                assign p1[k] = bp[k];
                assign g1[k] = bg[k];
            end
            if (k >= 2) begin : s2
                assign p2[k] = p1[k] & p1[k-2];
                assign g2[k] = g1[k] | (p1[k] & g1[k-2]);
            end else begin : s2_pass
                assign p2[k] = p1[k];
                assign g2[k] = g1[k];
            end
            if (k >= 4) begin : s3
                assign p3[k] = p2[k] & p2[k-4];
                assign g3[k] = g2[k] | (p2[k] & g2[k-4]);
            end else begin : s3_pass
                assign p3[k] = p2[k];
                assign g3[k] = g2[k];
            end
            if (k >= 8) begin : s4
                assign p4[k] = p3[k] & p3[k-8];
                assign g4[k] = g3[k] | (p3[k] & g3[k-8]);
            end else begin : s4_pass
                assign p4[k] = p3[k];
                assign g4[k] = g3[k];
            end
        end
        for (k = 0; k < 16; k = k + 1) begin : local_carries
            if (k == 0) begin : first_block
                assign block_c[k] = subtract;
            end else begin : later_block
                assign block_c[k] = g4[k-1] | (p4[k-1] & subtract);
            end
            assign carry[4*k] = block_c[k];
            assign carry[4*k+1] = g[4*k]
                                    | (p[4*k] & block_c[k]);
            assign carry[4*k+2] = g[4*k+1]
                                    | (p[4*k+1] & g[4*k])
                                    | (p[4*k+1] & p[4*k] & block_c[k]);
            assign carry[4*k+3] = g[4*k+2]
                                    | (p[4*k+2] & g[4*k+1])
                                    | (p[4*k+2] & p[4*k+1] & g[4*k])
                                    | (p[4*k+2] & p[4*k+1] & p[4*k] & block_c[k]);
        end
    endgenerate

    assign arithmetic_result = bit_xor ^ carry;
    assign logic_result = ((a | b) & {64{do_or}})
                        | ((a & b) & {64{do_and}})
                        | ((a ^ b) & {64{do_xor}})
                        | ((a ~^ b) & {64{do_xnor}});
    always @* begin
        sum = (arithmetic_result & {64{arithmetic_enable}}) | logic_result;
    end
endmodule
