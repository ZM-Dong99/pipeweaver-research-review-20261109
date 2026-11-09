module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] x, y, p, g;
    wire cin;
    wire [31:0] group_p [0:5];
    wire [31:0] group_g [0:5];
    wire [63:0] carry;
    wire [63:0] arithmetic_result;
    wire arithmetic_enable;
    wire or_enable, and_enable, xor_enable, xnor_enable;

    // These operand transformations are used only for operations 000-010.
    assign x = a ^ {64{Oper[1]}};
    assign y = b ^ {64{Oper[0]}};
    assign cin = Oper[0] | Oper[1];
    assign p = x ^ y;
    assign g = x & y;

    // Two-bit groups, with the input carry absorbed into group zero.
    genvar j;
    generate
        for (j = 0; j < 32; j = j + 1) begin : make_groups
            assign group_p[0][j] = p[2*j+1] & p[2*j];
            if (j == 0) begin : first_group
                assign group_g[0][j] = g[1] |
                    (p[1] & g[0]) |
                    (p[1] & p[0] & cin);
            end else begin : other_group
                assign group_g[0][j] = g[2*j+1] |
                    (p[2*j+1] & g[2*j]);
            end
        end
    endgenerate

    // Parallel prefix across the 32 two-bit groups.
    genvar level, k;
    generate
        for (level = 0; level < 5; level = level + 1) begin : prefix_level
            for (k = 0; k < 32; k = k + 1) begin : prefix_node
                if (k >= (1 << level)) begin : combine
                    assign group_g[level+1][k] = group_g[level][k] |
                        (group_p[level][k] & group_g[level][k-(1 << level)]);
                    assign group_p[level+1][k] = group_p[level][k] &
                        group_p[level][k-(1 << level)];
                end else begin : pass_through
                    assign group_g[level+1][k] = group_g[level][k];
                    assign group_p[level+1][k] = group_p[level][k];
                end
            end
        end
    endgenerate

    assign carry[0] = cin;
    genvar n;
    generate
        for (n = 0; n < 32; n = n + 1) begin : finish_groups
            if (n != 0) begin : group_input
                assign carry[2*n] = group_g[5][n-1];
            end
            assign carry[2*n+1] = g[2*n] | (p[2*n] & carry[2*n]);
        end
    endgenerate
    assign arithmetic_result = p ^ carry;

    assign arithmetic_enable = ~Oper[2] & ~(Oper[1] & Oper[0]);
    assign or_enable   = (Oper == 3'b011);
    assign and_enable  = (Oper == 3'b100);
    assign xor_enable  = (Oper == 3'b101);
    assign xnor_enable = (Oper == 3'b110);

    always @(*) begin
        sum = (arithmetic_result & {64{arithmetic_enable}}) |
              ((a | b) & {64{or_enable}}) |
              ((a & b) & {64{and_enable}}) |
              ((a ^ b) & {64{xor_enable}}) |
              ((a ~^ b) & {64{xnor_enable}});
    end
endmodule
