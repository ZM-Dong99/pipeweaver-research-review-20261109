module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    localparam BLOCKS = (WIDTH + 3) / 4;
    localparam PAD_WIDTH = 4 * BLOCKS;
    localparam LEVELS = $clog2(BLOCKS);

    wire sub_ab = (Oper == 3'b001);
    wire sub_ba = (Oper == 3'b010);
    wire subtracting = sub_ab | sub_ba;
    wire [WIDTH-1:0] axb = a ^ b;
    wire [PAD_WIDTH-1:0] p, g;
    wire [BLOCKS-1:0] block_p, block_g;
    wire [BLOCKS-1:0] prefix_p [0:LEVELS];
    wire [BLOCKS-1:0] prefix_g [0:LEVELS];
    wire [BLOCKS-1:0] block_c;
    wire [WIDTH-1:0] bit_c;
    wire [WIDTH-1:0] arithmetic_result;

    genvar i, j, level;
    generate
        for (i = 0; i < PAD_WIDTH; i = i + 1) begin : bit_terms
            if (i < WIDTH) begin : active
                assign p[i] = axb[i] ^ subtracting;
                assign g[i] = (a[i] ^ sub_ab) & (b[i] ^ sub_ba);
            end else begin : padding
                assign p[i] = 1'b1;
                assign g[i] = 1'b0;
            end
        end

        for (j = 0; j < BLOCKS; j = j + 1) begin : groups
            assign block_p[j] = &p[4*j +: 4];
            assign block_g[j] = g[4*j+3]
                | (p[4*j+3] & g[4*j+2])
                | (p[4*j+3] & p[4*j+2] & g[4*j+1])
                | (p[4*j+3] & p[4*j+2] & p[4*j+1] & g[4*j]);
        end
    endgenerate

    assign prefix_p[0] = block_p;
    assign prefix_g[0] = block_g;

    generate
        for (level = 0; level < LEVELS; level = level + 1) begin : prefix_levels
            for (j = 0; j < BLOCKS; j = j + 1) begin : prefix_nodes
                if (j >= (1 << level)) begin : combine
                    assign prefix_g[level+1][j] = prefix_g[level][j]
                        | (prefix_p[level][j] & prefix_g[level][j-(1 << level)]);
                    assign prefix_p[level+1][j] = prefix_p[level][j]
                        & prefix_p[level][j-(1 << level)];
                end else begin : pass_through
                    assign prefix_g[level+1][j] = prefix_g[level][j];
                    assign prefix_p[level+1][j] = prefix_p[level][j];
                end
            end
        end

        for (j = 0; j < BLOCKS; j = j + 1) begin : block_carries
            if (j == 0) begin : first
                assign block_c[j] = 1'b0;
            end else begin : remaining
                assign block_c[j] = prefix_g[LEVELS][j-1];
            end
        end

        for (i = 0; i < WIDTH; i = i + 1) begin : local_carries
            if ((i % 4) == 0) begin : offset_zero
                assign bit_c[i] = block_c[i/4];
            end else if ((i % 4) == 1) begin : offset_one
                assign bit_c[i] = g[i-1] | (p[i-1] & block_c[i/4]);
            end else if ((i % 4) == 2) begin : offset_two
                assign bit_c[i] = g[i-1]
                    | (p[i-1] & g[i-2])
                    | (p[i-1] & p[i-2] & block_c[i/4]);
            end else begin : offset_three
                assign bit_c[i] = g[i-1]
                    | (p[i-1] & g[i-2])
                    | (p[i-1] & p[i-2] & g[i-3])
                    | (p[i-1] & p[i-2] & p[i-3] & block_c[i/4]);
            end
        end
    endgenerate

    assign arithmetic_result = axb ^ bit_c;

    always @* begin
        case (Oper)
            3'b000: sum = arithmetic_result;
            3'b001: sum = arithmetic_result;
            3'b010: sum = arithmetic_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = axb;
            3'b110: sum = ~axb;
            default: sum = {WIDTH{1'b0}};
        endcase
    end
endmodule
