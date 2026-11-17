module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] x;
    wire [WIDTH-1:0] add_p, sub_p;
    wire [WIDTH-1:0] add_g, ab_g, ba_g;
    wire [WIDTH-1:0] add_c, ab_borrow, ba_borrow;
    wire [WIDTH-1:0] add_result, ab_result, ba_result;

    assign x = a ^ b;
    assign add_p = a | b;
    assign sub_p = ~x;
    assign add_g = a & b;
    assign ab_g = (~a) & b;
    assign ba_g = a & (~b);

    pw_alu_group_carry #(.WIDTH(WIDTH)) u_add (
        .p(add_p), .g(add_g), .c(add_c)
    );
    pw_alu_group_carry #(.WIDTH(WIDTH)) u_ab (
        .p(sub_p), .g(ab_g), .c(ab_borrow)
    );
    pw_alu_group_carry #(.WIDTH(WIDTH)) u_ba (
        .p(sub_p), .g(ba_g), .c(ba_borrow)
    );

    assign add_result = x ^ add_c;
    assign ab_result = x ^ ab_borrow;
    assign ba_result = x ^ ba_borrow;

    always @* begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = ab_result;
            3'b010: sum = ba_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = x;
            3'b110: sum = ~x;
            default: sum = {WIDTH{1'b0}};
        endcase
    end
endmodule

module pw_alu_group_carry #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] p,
    input wire [WIDTH-1:0] g,
    output wire [WIDTH-1:0] c
);
    localparam GROUPS = (WIDTH + 3) / 4;
    localparam PAD_WIDTH = GROUPS * 4;
    localparam LEVELS = $clog2(GROUPS);

    wire [PAD_WIDTH-1:0] pp, gg;
    wire [GROUPS-1:0] tree_p [0:LEVELS];
    wire [GROUPS-1:0] tree_g [0:LEVELS];
    wire [GROUPS-1:0] group_c;

    genvar i, j, s;
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

        for (j = 0; j < GROUPS; j = j + 1) begin: groups
            assign tree_p[0][j] = &pp[4*j +: 4];
            assign tree_g[0][j] = gg[4*j+3]
                | (pp[4*j+3] & gg[4*j+2])
                | (pp[4*j+3] & pp[4*j+2] & gg[4*j+1])
                | (pp[4*j+3] & pp[4*j+2] & pp[4*j+1] & gg[4*j]);
            if (j == 0) begin: first_group
                assign group_c[j] = 1'b0;
            end else begin: later_group
                assign group_c[j] = tree_g[LEVELS][j-1];
            end
        end

        for (s = 0; s < LEVELS; s = s + 1) begin: prefix_level
            for (j = 0; j < GROUPS; j = j + 1) begin: prefix_node
                if (j >= (1 << s)) begin: combine
                    assign tree_p[s+1][j] = tree_p[s][j]
                        & tree_p[s][j-(1 << s)];
                    assign tree_g[s+1][j] = tree_g[s][j]
                        | (tree_p[s][j] & tree_g[s][j-(1 << s)]);
                end else begin: pass_node
                    assign tree_p[s+1][j] = tree_p[s][j];
                    assign tree_g[s+1][j] = tree_g[s][j];
                end
            end
        end

        for (i = 0; i < WIDTH; i = i + 1) begin: bit_carry
            if ((i % 4) == 0) begin: offset_zero
                assign c[i] = group_c[i/4];
            end else if ((i % 4) == 1) begin: offset_one
                assign c[i] = gg[i-1]
                    | (pp[i-1] & group_c[i/4]);
            end else if ((i % 4) == 2) begin: offset_two
                assign c[i] = gg[i-1]
                    | (pp[i-1] & gg[i-2])
                    | (pp[i-1] & pp[i-2] & group_c[i/4]);
            end else begin: offset_three
                assign c[i] = gg[i-1]
                    | (pp[i-1] & gg[i-2])
                    | (pp[i-1] & pp[i-2] & gg[i-3])
                    | (pp[i-1] & pp[i-2] & pp[i-3] & group_c[i/4]);
            end
        end
    endgenerate
endmodule
