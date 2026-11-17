module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    localparam integer BLOCKS = (WIDTH + 3) / 4;
    localparam integer PAD_WIDTH = 4 * BLOCKS;
    localparam integer LEVELS = (BLOCKS > 1) ? $clog2(BLOCKS) : 0;

    wire neg_a = (Oper == 3'b010);
    wire neg_b = (Oper == 3'b001);
    wire cin = neg_a | neg_b;
    wire arithmetic_en = (Oper == 3'b000) | neg_a | neg_b;
    wire or_en   = (Oper == 3'b011);
    wire and_en  = (Oper == 3'b100);
    wire xor_en  = (Oper == 3'b101);
    wire xnor_en = (Oper == 3'b110);

    wire [PAD_WIDTH-1:0] p, g, carry;
    wire [BLOCKS-1:0] block_p, block_g, block_c;
    wire [BLOCKS-1:0] prefix_p [0:LEVELS];
    wire [BLOCKS-1:0] prefix_g [0:LEVELS];
    wire [WIDTH-1:0] arithmetic_result;

    genvar i, k, s;
    generate
        for (i = 0; i < PAD_WIDTH; i = i + 1) begin : bits_pg
            if (i < WIDTH) begin : real_bit
                wire x, y;
                assign x = a[i] ^ neg_a;
                assign y = b[i] ^ neg_b;
                assign p[i] = x ^ y;
                assign g[i] = x & y;
                assign arithmetic_result[i] = p[i] ^ carry[i];
            end else begin : padding
                assign p[i] = 1'b1;
                assign g[i] = 1'b0;
            end
        end

        for (k = 0; k < BLOCKS; k = k + 1) begin : blocks
            assign block_p[k] = p[4*k+3] & p[4*k+2] & p[4*k+1] & p[4*k];
            assign block_g[k] = g[4*k+3]
                              | (p[4*k+3] & g[4*k+2])
                              | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                              | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
            if (k == 0) begin : first_block
                assign prefix_p[0][k] = 1'b0;
                assign prefix_g[0][k] = block_g[k] | (block_p[k] & cin);
                assign block_c[k] = cin;
            end else begin : later_block
                assign prefix_p[0][k] = block_p[k];
                assign prefix_g[0][k] = block_g[k];
                assign block_c[k] = prefix_g[LEVELS][k-1];
            end

            assign carry[4*k] = block_c[k];
            assign carry[4*k+1] = g[4*k] | (p[4*k] & block_c[k]);
            assign carry[4*k+2] = g[4*k+1]
                                | (p[4*k+1] & g[4*k])
                                | (p[4*k+1] & p[4*k] & block_c[k]);
            assign carry[4*k+3] = g[4*k+2]
                                | (p[4*k+2] & g[4*k+1])
                                | (p[4*k+2] & p[4*k+1] & g[4*k])
                                | (p[4*k+2] & p[4*k+1] & p[4*k] & block_c[k]);
        end

        for (s = 0; s < LEVELS; s = s + 1) begin : prefix_levels
            for (k = 0; k < BLOCKS; k = k + 1) begin : prefix_nodes
                if (k >= (1 << s)) begin : combine
                    assign prefix_g[s+1][k] = prefix_g[s][k]
                        | (prefix_p[s][k] & prefix_g[s][k-(1 << s)]);
                    assign prefix_p[s+1][k] = prefix_p[s][k]
                        & prefix_p[s][k-(1 << s)];
                end else begin : passthrough
                    assign prefix_g[s+1][k] = prefix_g[s][k];
                    assign prefix_p[s+1][k] = prefix_p[s][k];
                end
            end
        end
    endgenerate

    always @* begin
        sum = (arithmetic_result & {WIDTH{arithmetic_en}})
            | ((a | b) & {WIDTH{or_en}})
            | ((a & b) & {WIDTH{and_en}})
            | ((a ^ b) & {WIDTH{xor_en}})
            | ((a ~^ b) & {WIDTH{xnor_en}});
    end
endmodule
