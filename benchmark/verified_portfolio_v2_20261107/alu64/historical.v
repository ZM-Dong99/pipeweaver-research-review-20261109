module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire sub_ab;
    wire sub_ba;
    wire cin;
    wire [63:0] x, y, p, g;
    wire [63:0] arith_sum;
    wire [15:0] gp [0:4];
    wire [15:0] gg [0:4];
    wire [15:0] block_cin;

    assign sub_ab = (Oper == 3'b001);
    assign sub_ba = (Oper == 3'b010);
    assign cin = sub_ab | sub_ba;

    // a+b, a+~b+1, or ~a+b+1, respectively.
    assign x = a ^ {64{sub_ba}};
    assign y = b ^ {64{sub_ab}};
    assign p = x ^ y;
    assign g = x & y;

    // Four-bit group propagate and generate signals.
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : groups
            assign gp[0][k] = &p[4*k +: 4];
            assign gg[0][k] = g[4*k+3]
                            | (p[4*k+3] & g[4*k+2])
                            | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                            | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
        end
    endgenerate

    // Parallel prefix over the sixteen four-bit groups.
    genvar level, j;
    generate
        for (level = 0; level < 4; level = level + 1) begin : prefix_levels
            for (j = 0; j < 16; j = j + 1) begin : prefix_nodes
                if (j >= (1 << level)) begin : combine
                    assign gp[level+1][j] = gp[level][j]
                                              & gp[level][j-(1 << level)];
                    assign gg[level+1][j] = gg[level][j]
                                              | (gp[level][j]
                                                 & gg[level][j-(1 << level)]);
                end else begin : pass_through
                    assign gp[level+1][j] = gp[level][j];
                    assign gg[level+1][j] = gg[level][j];
                end
            end
        end
    endgenerate

    assign block_cin[0] = cin;
    generate
        for (k = 1; k < 16; k = k + 1) begin : block_carries
            assign block_cin[k] = gg[4][k-1] | (gp[4][k-1] & cin);
        end
        for (k = 0; k < 16; k = k + 1) begin : local_sums
            wire c0, c1, c2, c3;
            assign c0 = block_cin[k];
            assign c1 = g[4*k] | (p[4*k] & c0);
            assign c2 = g[4*k+1]
                      | (p[4*k+1] & g[4*k])
                      | (p[4*k+1] & p[4*k] & c0);
            assign c3 = g[4*k+2]
                      | (p[4*k+2] & g[4*k+1])
                      | (p[4*k+2] & p[4*k+1] & g[4*k])
                      | (p[4*k+2] & p[4*k+1] & p[4*k] & c0);
            assign arith_sum[4*k +: 4] = p[4*k +: 4] ^ {c3, c2, c1, c0};
        end
    endgenerate

    always @(*) begin
        case (Oper)
            3'b000: sum = arith_sum;
            3'b001: sum = arith_sum;
            3'b010: sum = arith_sum;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = 64'b0;
        endcase
    end
endmodule
