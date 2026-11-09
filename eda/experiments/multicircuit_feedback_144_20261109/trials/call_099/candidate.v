module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] x, y, p, g;
    wire cin;
    wire [15:0] gp [0:4];
    wire [15:0] gg [0:4];
    wire [63:0] arithmetic_result;
    wire arithmetic_enable, or_enable, and_enable;
    wire xor_enable, xnor_enable;

    // For arithmetic operations, complement only the subtrahend.
    assign x = a ^ {64{Oper[1]}};
    assign y = b ^ {64{Oper[0]}};
    assign cin = Oper[1] | Oper[0];
    assign p = x ^ y;
    assign g = x & y;

    genvar k, s, j;
    generate
        for (k = 0; k < 16; k = k + 1) begin : group_terms
            assign gp[0][k] = p[4*k+3] & p[4*k+2] &
                              p[4*k+1] & p[4*k];
            assign gg[0][k] = g[4*k+3] |
                              (p[4*k+3] & g[4*k+2]) |
                              (p[4*k+3] & p[4*k+2] & g[4*k+1]) |
                              (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
        end
        for (s = 0; s < 4; s = s + 1) begin : prefix_stage
            for (j = 0; j < 16; j = j + 1) begin : prefix_column
                if (j >= (1 << s)) begin : combine
                    assign gp[s+1][j] = gp[s][j] & gp[s][j-(1 << s)];
                    assign gg[s+1][j] = gg[s][j] |
                                       (gp[s][j] & gg[s][j-(1 << s)]);
                end else begin : pass_through
                    assign gp[s+1][j] = gp[s][j];
                    assign gg[s+1][j] = gg[s][j];
                end
            end
        end
        for (k = 0; k < 16; k = k + 1) begin : local_carries
            wire [3:0] c;
            if (k == 0) begin : first_group
                assign c[0] = cin;
            end else begin : later_group
                assign c[0] = gg[4][k-1] | (gp[4][k-1] & cin);
            end
            assign c[1] = g[4*k] | (p[4*k] & c[0]);
            assign c[2] = g[4*k+1] |
                          (p[4*k+1] & g[4*k]) |
                          (p[4*k+1] & p[4*k] & c[0]);
            assign c[3] = g[4*k+2] |
                          (p[4*k+2] & g[4*k+1]) |
                          (p[4*k+2] & p[4*k+1] & g[4*k]) |
                          (p[4*k+2] & p[4*k+1] & p[4*k] & c[0]);
            assign arithmetic_result[4*k +: 4] = p[4*k +: 4] ^ c;
        end
    endgenerate

    assign arithmetic_enable = ~Oper[2] & ~(Oper[1] & Oper[0]);
    assign or_enable   = (Oper == 3'b011);
    assign and_enable  = (Oper == 3'b100);
    assign xor_enable  = (Oper == 3'b101);
    assign xnor_enable = (Oper == 3'b110);

    always @* begin
        sum = (arithmetic_result & {64{arithmetic_enable}}) |
              ((a | b) & {64{or_enable}}) |
              ((a & b) & {64{and_enable}}) |
              ((a ^ b) & {64{xor_enable}}) |
              ((a ~^ b) & {64{xnor_enable}});
    end
endmodule
