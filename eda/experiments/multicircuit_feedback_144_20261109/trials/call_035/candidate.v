module alu64_cla4(
    input  [63:0] x,
    input  [63:0] y,
    input         cin,
    output [63:0] s,
    output        cout
);
    wire [63:0] p;
    wire [63:0] g;
    wire [64:0] c;
    wire [16:0] bc;
    wire [15:0] bp;
    wire [15:0] bg;

    assign p = x ^ y;
    assign g = x & y;
    assign bc[0] = cin;

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : CLA_BLOCK
            assign bp[k] = p[4*k] & p[4*k+1] & p[4*k+2] & p[4*k+3];
            assign bg[k] = g[4*k+3] |
                           (p[4*k+3] & g[4*k+2]) |
                           (p[4*k+3] & p[4*k+2] & g[4*k+1]) |
                           (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);
            assign bc[k+1] = bg[k] | (bp[k] & bc[k]);
            assign c[4*k] = bc[k];
            assign c[4*k+1] = g[4*k] | (p[4*k] & c[4*k]);
            assign c[4*k+2] = g[4*k+1] |
                              (p[4*k+1] & g[4*k]) |
                              (p[4*k+1] & p[4*k] & c[4*k]);
            assign c[4*k+3] = g[4*k+2] |
                              (p[4*k+2] & g[4*k+1]) |
                              (p[4*k+2] & p[4*k+1] & g[4*k]) |
                              (p[4*k+2] & p[4*k+1] & p[4*k] & c[4*k]);
        end
    endgenerate

    assign c[64] = bc[16];
    assign s = p ^ c[63:0];
    assign cout = c[64];
endmodule

module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] arithmetic_a;
    wire [63:0] arithmetic_b;
    wire [63:0] arithmetic_y;
    wire [63:0] arithmetic_sum;
    wire arithmetic_cout;

    assign arithmetic_a = (Oper == 3'b010) ? b : a;
    assign arithmetic_b = (Oper == 3'b010) ? a : b;
    assign arithmetic_y = arithmetic_b ^ {64{Oper[0]}};

    alu64_cla4 arithmetic_unit(
        .x(arithmetic_a),
        .y(arithmetic_y),
        .cin(Oper[0]),
        .s(arithmetic_sum),
        .cout(arithmetic_cout)
    );

    always @(*) begin
        case (Oper)
            3'b000: sum = arithmetic_sum;
            3'b001: sum = arithmetic_sum;
            3'b010: sum = arithmetic_sum;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = 64'b0;
        endcase
    end
endmodule
