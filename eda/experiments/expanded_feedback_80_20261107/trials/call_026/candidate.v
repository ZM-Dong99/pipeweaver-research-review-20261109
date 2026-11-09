module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire sub_ab;
    wire sub_ba;
    wire cin;
    wire [63:0] x, y;
    wire [63:0] p, g, sx;
    wire [63:0] carry;
    wire [63:0] arithmetic_result;
    wire [15:0] block_p, block_g;
    wire [15:0] prefix_p [0:4];
    wire [15:0] prefix_g [0:4];

    assign sub_ab = (Oper == 3'b001);
    assign sub_ba = (Oper == 3'b010);
    assign cin = sub_ab | sub_ba;
    assign x = a ^ {64{sub_ba}};
    assign y = b ^ {64{sub_ab}};
    assign sx = x ^ y;
    assign p = x | y;
    assign g = x & y;

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : blocks
            wire p01, g01;
            wire p23, g23;
            wire p012, g012;

            assign p01 = p[4*k+1] & p[4*k];
            assign g01 = g[4*k+1] | (p[4*k+1] & g[4*k]);
            assign p23 = p[4*k+3] & p[4*k+2];
            assign g23 = g[4*k+3] | (p[4*k+3] & g[4*k+2]);
            assign p012 = p[4*k+2] & p01;
            assign g012 = g[4*k+2] | (p[4*k+2] & g01);
            assign block_p[k] = p23 & p01;
            assign block_g[k] = g23 | (p23 & g01);

            if (k == 0) begin : first_block
                assign carry[4*k] = cin;
            end else begin : later_block
                assign carry[4*k] = prefix_g[4][k-1];
            end
            assign carry[4*k+1] = g[4*k] | (p[4*k] & carry[4*k]);
            assign carry[4*k+2] = g01 | (p01 & carry[4*k]);
            assign carry[4*k+3] = g012 | (p012 & carry[4*k]);
        end
    endgenerate

    assign prefix_p[0] = block_p;
    assign prefix_g[0] = {block_g[15:1], (block_g[0] | (block_p[0] & cin))};

    genvar stage, column;
    generate
        for (stage = 0; stage < 4; stage = stage + 1) begin : prefix_stages
            for (column = 0; column < 16; column = column + 1) begin : prefix_columns
                if (column >= (1 << stage)) begin : combine
                    assign prefix_g[stage+1][column] =
                        prefix_g[stage][column] |
                        (prefix_p[stage][column] &
                         prefix_g[stage][column-(1 << stage)]);
                    assign prefix_p[stage+1][column] =
                        prefix_p[stage][column] &
                        prefix_p[stage][column-(1 << stage)];
                end else begin : pass_through
                    assign prefix_g[stage+1][column] = prefix_g[stage][column];
                    assign prefix_p[stage+1][column] = prefix_p[stage][column];
                end
            end
        end
    endgenerate

    assign arithmetic_result = sx ^ carry;

    always @(*) begin
        case (Oper)
            3'b000, 3'b001, 3'b010: sum = arithmetic_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = 64'b0;
        endcase
    end
endmodule
