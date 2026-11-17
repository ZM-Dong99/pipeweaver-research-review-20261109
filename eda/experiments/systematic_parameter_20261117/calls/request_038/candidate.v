module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] x;
    wire [WIDTH-1:0] add_c, ab_c, ba_c;
    wire [WIDTH-1:0] add_p, add_g, ab_p, ab_g, ba_p, ba_g;
    wire s_add, s_ab, s_ba, s_or, s_and, s_xor, s_xnor;

    assign x = a ^ b;
    assign add_p = a | b;
    assign add_g = a & b;
    assign ab_p = ~a | b;
    assign ab_g = ~a & b;
    assign ba_p = a | ~b;
    assign ba_g = a & ~b;

    pw_alu_carry4 #(.WIDTH(WIDTH)) u_add (
        .p(add_p), .g(add_g), .c(add_c)
    );
    pw_alu_carry4 #(.WIDTH(WIDTH)) u_ab (
        .p(ab_p), .g(ab_g), .c(ab_c)
    );
    pw_alu_carry4 #(.WIDTH(WIDTH)) u_ba (
        .p(ba_p), .g(ba_g), .c(ba_c)
    );

    assign s_add  = (Oper == 3'b000);
    assign s_ab   = (Oper == 3'b001);
    assign s_ba   = (Oper == 3'b010);
    assign s_or   = (Oper == 3'b011);
    assign s_and  = (Oper == 3'b100);
    assign s_xor  = (Oper == 3'b101);
    assign s_xnor = (Oper == 3'b110);

    always @* begin
        sum = ({WIDTH{s_add}}  & (x ^ add_c))
            | ({WIDTH{s_ab}}   & (x ^ ab_c))
            | ({WIDTH{s_ba}}   & (x ^ ba_c))
            | ({WIDTH{s_or}}   & (a | b))
            | ({WIDTH{s_and}}  & (a & b))
            | ({WIDTH{s_xor}}  & x)
            | ({WIDTH{s_xnor}} & ~x);
    end
endmodule

module pw_alu_carry4 #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] p,
    input wire [WIDTH-1:0] g,
    output wire [WIDTH-1:0] c
);
    function integer levels4;
        input integer n;
        integer v;
        begin
            v = n;
            levels4 = 0;
            while (v > 1) begin
                v = (v + 3) / 4;
                levels4 = levels4 + 1;
            end
        end
    endfunction

    localparam integer NG = (WIDTH + 3) / 4;
    localparam integer PAD = 4 * NG;
    localparam integer NL = levels4(NG);
    wire [PAD-1:0] bp, bg;
    wire [NG-1:0] pp [0:NL];
    wire [NG-1:0] gg [0:NL];
    wire [NG-1:0] boundary;

    genvar i, j, l;
    generate
        for (i = 0; i < PAD; i = i + 1) begin: bits_pad
            if (i < WIDTH) begin: real_bit
                assign bp[i] = p[i];
                assign bg[i] = g[i];
            end else begin: pad_bit
                assign bp[i] = 1'b1;
                assign bg[i] = 1'b0;
            end
        end

        for (j = 0; j < NG; j = j + 1) begin: groups
            assign pp[0][j] = bp[4*j+3] & bp[4*j+2]
                            & bp[4*j+1] & bp[4*j];
            assign gg[0][j] = bg[4*j+3]
                            | (bp[4*j+3] & bg[4*j+2])
                            | (bp[4*j+3] & bp[4*j+2] & bg[4*j+1])
                            | (bp[4*j+3] & bp[4*j+2] & bp[4*j+1] & bg[4*j]);
            if (j == 0) begin: first_group
                assign boundary[j] = 1'b0;
            end else begin: later_group
                assign boundary[j] = gg[NL][j-1];
            end
        end

        for (l = 0; l < NL; l = l + 1) begin: prefix_level
            localparam integer D = 4 ** l;
            for (j = 0; j < NG; j = j + 1) begin: prefix_group
                if (j >= 3*D) begin: four
                    assign pp[l+1][j] = pp[l][j] & pp[l][j-D]
                                       & pp[l][j-2*D] & pp[l][j-3*D];
                    assign gg[l+1][j] = gg[l][j]
                        | (pp[l][j] & gg[l][j-D])
                        | (pp[l][j] & pp[l][j-D] & gg[l][j-2*D])
                        | (pp[l][j] & pp[l][j-D] & pp[l][j-2*D] & gg[l][j-3*D]);
                end else if (j >= 2*D) begin: three
                    assign pp[l+1][j] = pp[l][j] & pp[l][j-D] & pp[l][j-2*D];
                    assign gg[l+1][j] = gg[l][j]
                        | (pp[l][j] & gg[l][j-D])
                        | (pp[l][j] & pp[l][j-D] & gg[l][j-2*D]);
                end else if (j >= D) begin: two
                    assign pp[l+1][j] = pp[l][j] & pp[l][j-D];
                    assign gg[l+1][j] = gg[l][j] | (pp[l][j] & gg[l][j-D]);
                end else begin: one
                    assign pp[l+1][j] = pp[l][j];
                    assign gg[l+1][j] = gg[l][j];
                end
            end
        end

        for (i = 0; i < WIDTH; i = i + 1) begin: local_carry
            if ((i % 4) == 0) begin: offset0
                assign c[i] = boundary[i/4];
            end else if ((i % 4) == 1) begin: offset1
                assign c[i] = bg[i-1] | (bp[i-1] & boundary[i/4]);
            end else if ((i % 4) == 2) begin: offset2
                assign c[i] = bg[i-1]
                    | (bp[i-1] & bg[i-2])
                    | (bp[i-1] & bp[i-2] & boundary[i/4]);
            end else begin: offset3
                assign c[i] = bg[i-1]
                    | (bp[i-1] & bg[i-2])
                    | (bp[i-1] & bp[i-2] & bg[i-3])
                    | (bp[i-1] & bp[i-2] & bp[i-3] & boundary[i/4]);
            end
        end
    endgenerate
endmodule
