module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] x;
    wire [WIDTH-1:0] add_g, ab_g, ba_g;
    wire [WIDTH-1:0] add_c, ab_c, ba_c;
    wire [WIDTH-1:0] add_result, ab_result, ba_result;
    wire sel_add, sel_ab, sel_ba;
    wire sel_or, sel_and, sel_xor, sel_xnor;

    assign x = a ^ b;
    assign add_g = a & b;
    assign ab_g = (~a) & b;
    assign ba_g = a & (~b);

    pw_alu_carry4 #(.WIDTH(WIDTH)) u_add (
        .p(x), .g(add_g), .c(add_c)
    );
    pw_alu_carry4 #(.WIDTH(WIDTH)) u_ab (
        .p(~x), .g(ab_g), .c(ab_c)
    );
    pw_alu_carry4 #(.WIDTH(WIDTH)) u_ba (
        .p(~x), .g(ba_g), .c(ba_c)
    );

    assign add_result = x ^ add_c;
    assign ab_result = x ^ ab_c;
    assign ba_result = x ^ ba_c;

    assign sel_add  = (Oper == 3'b000);
    assign sel_ab   = (Oper == 3'b001);
    assign sel_ba   = (Oper == 3'b010);
    assign sel_or   = (Oper == 3'b011);
    assign sel_and  = (Oper == 3'b100);
    assign sel_xor  = (Oper == 3'b101);
    assign sel_xnor = (Oper == 3'b110);

    always @* begin
        sum = ({WIDTH{sel_add}} & add_result)
            | ({WIDTH{sel_ab}} & ab_result)
            | ({WIDTH{sel_ba}} & ba_result)
            | ({WIDTH{sel_or}} & (a | b))
            | ({WIDTH{sel_and}} & (a & b))
            | ({WIDTH{sel_xor}} & x)
            | ({WIDTH{sel_xnor}} & (~x));
    end
endmodule

module pw_alu_carry4 #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] p,
    input wire [WIDTH-1:0] g,
    output wire [WIDTH-1:0] c
);
    localparam BLOCKS = (WIDTH + 3) / 4;
    localparam PAD_WIDTH = 4 * BLOCKS;
    localparam LEVELS = $clog2(BLOCKS);

    wire [PAD_WIDTH-1:0] pp, gg;
    wire [BLOCKS-1:0] bp [0:LEVELS];
    wire [BLOCKS-1:0] bg [0:LEVELS];
    wire [BLOCKS-1:0] block_c;

    genvar i, j, s;
    generate
        for (i = 0; i < PAD_WIDTH; i = i + 1) begin: padding
            if (i < WIDTH) begin: real_bit
                assign pp[i] = p[i];
                assign gg[i] = g[i];
            end else begin: neutral_bit
                assign pp[i] = 1'b1;
                assign gg[i] = 1'b0;
            end
        end

        for (j = 0; j < BLOCKS; j = j + 1) begin: groups
            assign bp[0][j] = &pp[4*j +: 4];
            assign bg[0][j] = gg[4*j+3]
                | (pp[4*j+3] & gg[4*j+2])
                | (pp[4*j+3] & pp[4*j+2] & gg[4*j+1])
                | (pp[4*j+3] & pp[4*j+2] & pp[4*j+1] & gg[4*j]);
        end

        for (s = 0; s < LEVELS; s = s + 1) begin: prefix_level
            for (j = 0; j < BLOCKS; j = j + 1) begin: prefix_node
                if (j >= (1 << s)) begin: combine
                    assign bp[s+1][j] = bp[s][j] & bp[s][j-(1 << s)];
                    assign bg[s+1][j] = bg[s][j]
                        | (bp[s][j] & bg[s][j-(1 << s)]);
                end else begin: pass
                    assign bp[s+1][j] = bp[s][j];
                    assign bg[s+1][j] = bg[s][j];
                end
            end
        end

        for (j = 0; j < BLOCKS; j = j + 1) begin: block_inputs
            if (j == 0) begin: first
                assign block_c[j] = 1'b0;
            end else begin: later
                assign block_c[j] = bg[LEVELS][j-1];
            end
        end

        for (i = 0; i < WIDTH; i = i + 1) begin: local_carries
            if ((i % 4) == 0) begin: bit0
                assign c[i] = block_c[i/4];
            end else if ((i % 4) == 1) begin: bit1
                assign c[i] = gg[i-1]
                    | (pp[i-1] & block_c[i/4]);
            end else if ((i % 4) == 2) begin: bit2
                assign c[i] = gg[i-1]
                    | (pp[i-1] & gg[i-2])
                    | (pp[i-1] & pp[i-2] & block_c[i/4]);
            end else begin: bit3
                assign c[i] = gg[i-1]
                    | (pp[i-1] & gg[i-2])
                    | (pp[i-1] & pp[i-2] & gg[i-3])
                    | (pp[i-1] & pp[i-2] & pp[i-3] & block_c[i/4]);
            end
        end
    endgenerate
endmodule
