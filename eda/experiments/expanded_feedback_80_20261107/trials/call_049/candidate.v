module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire sub_ab;
    wire sub_ba;
    wire cin;
    wire [63:0] x, y;
    wire [63:0] p, t, g;
    wire [63:0] arithmetic_result;
    wire [15:0] gp [0:4];
    wire [15:0] gg [0:4];
    wire [15:0] block_carry;

    assign sub_ab = (Oper == 3'b001);
    assign sub_ba = (Oper == 3'b010);
    assign cin = sub_ab | sub_ba;
    assign x = a ^ {64{sub_ba}};
    assign y = b ^ {64{sub_ab}};
    assign p = x ^ y;
    assign t = x | y;
    assign g = x & y;

    genvar k, s, q;
    generate
        for (k = 0; k < 16; k = k + 1) begin : make_groups
            assign gp[0][k] = &t[4*k +: 4];
            assign gg[0][k] = g[4*k+3]
                            | (t[4*k+3] & g[4*k+2])
                            | (t[4*k+3] & t[4*k+2] & g[4*k+1])
                            | (t[4*k+3] & t[4*k+2] & t[4*k+1] & g[4*k]);
        end
        for (s = 0; s < 4; s = s + 1) begin : prefix_level
            for (q = 0; q < 16; q = q + 1) begin : prefix_node
                if (q >= (1 << s)) begin : combine
                    assign gp[s+1][q] = gp[s][q] & gp[s][q-(1 << s)];
                    assign gg[s+1][q] = gg[s][q]
                                             | (gp[s][q] & gg[s][q-(1 << s)]);
                end else begin : pass_through
                    assign gp[s+1][q] = gp[s][q];
                    assign gg[s+1][q] = gg[s][q];
                end
            end
        end
        for (k = 0; k < 16; k = k + 1) begin : finish_groups
            wire [3:0] c;
            if (k == 0) begin : first_group
                assign block_carry[k] = cin;
            end else begin : later_group
                assign block_carry[k] = gg[4][k-1] | (gp[4][k-1] & cin);
            end
            assign c[0] = block_carry[k];
            assign c[1] = g[4*k] | (t[4*k] & c[0]);
            assign c[2] = g[4*k+1]
                        | (t[4*k+1] & g[4*k])
                        | (t[4*k+1] & t[4*k] & c[0]);
            assign c[3] = g[4*k+2]
                        | (t[4*k+2] & g[4*k+1])
                        | (t[4*k+2] & t[4*k+1] & g[4*k])
                        | (t[4*k+2] & t[4*k+1] & t[4*k] & c[0]);
            assign arithmetic_result[4*k +: 4] = p[4*k +: 4] ^ c;
        end
    endgenerate

    always @(*) begin
        case (Oper)
            3'b000: sum = arithmetic_result;
            3'b001: sum = arithmetic_result;
            3'b010: sum = arithmetic_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = 64'b0;
        endcase
    end
endmodule
