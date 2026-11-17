module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] p = a ^ b;
    wire [WIDTH-1:0] np = ~p;
    wire [WIDTH-1:0] ga = a & b;
    wire [WIDTH-1:0] gs = a & ~b;
    wire [WIDTH-1:0] gr = b & ~a;
    wire [WIDTH-1:0] ca, cs, cr;
    wire [WIDTH-1:0] add_result = p ^ ca;
    wire [WIDTH-1:0] sub_result = np ^ cs;
    wire [WIDTH-1:0] reverse_result = np ^ cr;

    pw_alu_carry #(.WIDTH(WIDTH)) u_add (
        .p(p), .g(ga), .cin(1'b0), .c(ca)
    );
    pw_alu_carry #(.WIDTH(WIDTH)) u_sub (
        .p(np), .g(gs), .cin(1'b1), .c(cs)
    );
    pw_alu_carry #(.WIDTH(WIDTH)) u_reverse (
        .p(np), .g(gr), .cin(1'b1), .c(cr)
    );

    wire sel_add = (Oper == 3'b000);
    wire sel_sub = (Oper == 3'b001);
    wire sel_reverse = (Oper == 3'b010);
    wire sel_or = (Oper == 3'b011);
    wire sel_and = (Oper == 3'b100);
    wire sel_xor = (Oper == 3'b101);
    wire sel_xnor = (Oper == 3'b110);

    always @* begin
        sum = ({WIDTH{sel_add}} & add_result)
            | ({WIDTH{sel_sub}} & sub_result)
            | ({WIDTH{sel_reverse}} & reverse_result)
            | ({WIDTH{sel_or}} & (a | b))
            | ({WIDTH{sel_and}} & ga)
            | ({WIDTH{sel_xor}} & p)
            | ({WIDTH{sel_xnor}} & np);
    end
endmodule

module pw_alu_carry #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] p,
    input wire [WIDTH-1:0] g,
    input wire cin,
    output wire [WIDTH-1:0] c
);
    localparam BLOCKS = (WIDTH + 3) / 4;
    localparam PAD_WIDTH = 4 * BLOCKS;
    localparam LEVELS = $clog2(BLOCKS);
    wire [PAD_WIDTH-1:0] pp, gg;
    wire [BLOCKS-1:0] bp [0:LEVELS];
    wire [BLOCKS-1:0] bg [0:LEVELS];
    wire [BLOCKS-1:0] bc;
    wire [PAD_WIDTH-1:0] cc;

    genvar i, k, level;
    generate
        for (i = 0; i < PAD_WIDTH; i = i + 1) begin: pad
            if (i < WIDTH) begin: real_bit
                assign pp[i] = p[i];
                assign gg[i] = g[i];
            end else begin: unused_bit
                assign pp[i] = 1'b1;
                assign gg[i] = 1'b0;
            end
        end
        for (k = 0; k < BLOCKS; k = k + 1) begin: block_terms
            assign bp[0][k] = &pp[4*k +: 4];
            assign bg[0][k] = gg[4*k+3]
                | (pp[4*k+3] & gg[4*k+2])
                | (pp[4*k+3] & pp[4*k+2] & gg[4*k+1])
                | (pp[4*k+3] & pp[4*k+2] & pp[4*k+1] & gg[4*k]);
        end
        for (level = 0; level < LEVELS; level = level + 1) begin: prefix_level
            for (k = 0; k < BLOCKS; k = k + 1) begin: prefix_node
                if (k >= (1 << level)) begin: combine
                    assign bp[level+1][k] = bp[level][k] & bp[level][k-(1 << level)];
                    assign bg[level+1][k] = bg[level][k]
                        | (bp[level][k] & bg[level][k-(1 << level)]);
                end else begin: bypass
                    assign bp[level+1][k] = bp[level][k];
                    assign bg[level+1][k] = bg[level][k];
                end
            end
        end
        for (k = 0; k < BLOCKS; k = k + 1) begin: local_carries
            if (k == 0) begin: first_block
                assign bc[k] = cin;
            end else begin: later_block
                assign bc[k] = bg[LEVELS][k-1] | (bp[LEVELS][k-1] & cin);
            end
            assign cc[4*k] = bc[k];
            assign cc[4*k+1] = gg[4*k] | (pp[4*k] & bc[k]);
            assign cc[4*k+2] = gg[4*k+1]
                | (pp[4*k+1] & gg[4*k])
                | (pp[4*k+1] & pp[4*k] & bc[k]);
            assign cc[4*k+3] = gg[4*k+2]
                | (pp[4*k+2] & gg[4*k+1])
                | (pp[4*k+2] & pp[4*k+1] & gg[4*k])
                | (pp[4*k+2] & pp[4*k+1] & pp[4*k] & bc[k]);
        end
    endgenerate
    assign c = cc[WIDTH-1:0];
endmodule
