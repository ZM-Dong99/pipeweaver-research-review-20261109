module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] add_result;
    wire [WIDTH-1:0] ab_result;
    wire [WIDTH-1:0] ba_result;

    pw_alu_sparse_add #(.WIDTH(WIDTH)) u_add (
        .x(a), .y(b), .cin(1'b0), .result(add_result)
    );
    pw_alu_sparse_add #(.WIDTH(WIDTH)) u_ab (
        .x(a), .y(~b), .cin(1'b1), .result(ab_result)
    );
    pw_alu_sparse_add #(.WIDTH(WIDTH)) u_ba (
        .x(b), .y(~a), .cin(1'b1), .result(ba_result)
    );

    always @* begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = ab_result;
            3'b010: sum = ba_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = a ^ b;
            3'b110: sum = a ~^ b;
            default: sum = {WIDTH{1'b0}};
        endcase
    end
endmodule

module pw_alu_sparse_add #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] x, y,
    input wire cin,
    output wire [WIDTH-1:0] result
);
    localparam GROUPS = (WIDTH + 3) / 4;
    localparam PAD_WIDTH = GROUPS * 4;
    localparam LEVELS = $clog2(GROUPS);

    wire [PAD_WIDTH-1:0] xp, yp;
    wire [PAD_WIDTH-1:0] p, g;
    wire [GROUPS-1:0] gp [0:LEVELS];
    wire [GROUPS-1:0] gg [0:LEVELS];
    wire [GROUPS-1:0] block_cin;
    wire [PAD_WIDTH-1:0] full_result;

    assign xp = {{(PAD_WIDTH-WIDTH){1'b0}}, x};
    assign yp = {{(PAD_WIDTH-WIDTH){1'b0}}, y};
    assign p = xp ^ yp;
    assign g = xp & yp;
    assign result = full_result[WIDTH-1:0];

    genvar k, level, n;
    generate
        for (k = 0; k < GROUPS; k = k + 1) begin : blocks
            wire [3:0] bp, bg;
            wire c1, c2, c3;
            assign bp = p[4*k +: 4];
            assign bg = g[4*k +: 4];
            assign gp[0][k] = &bp;
            assign gg[0][k] = bg[3]
                | (bp[3] & bg[2])
                | (bp[3] & bp[2] & bg[1])
                | (bp[3] & bp[2] & bp[1] & bg[0]);

            if (k == 0) begin : first_block
                assign block_cin[k] = cin;
            end else begin : later_block
                assign block_cin[k] = gg[LEVELS][k-1]
                    | (gp[LEVELS][k-1] & cin);
            end

            assign c1 = bg[0] | (bp[0] & block_cin[k]);
            assign c2 = bg[1] | (bp[1] & bg[0])
                | (bp[1] & bp[0] & block_cin[k]);
            assign c3 = bg[2] | (bp[2] & bg[1])
                | (bp[2] & bp[1] & bg[0])
                | (bp[2] & bp[1] & bp[0] & block_cin[k]);
            assign full_result[4*k +: 4] = bp ^ {c3, c2, c1, block_cin[k]};
        end

        for (level = 0; level < LEVELS; level = level + 1) begin : prefix_levels
            for (n = 0; n < GROUPS; n = n + 1) begin : prefix_nodes
                if (n >= (1 << level)) begin : combine
                    assign gp[level+1][n] = gp[level][n]
                        & gp[level][n-(1 << level)];
                    assign gg[level+1][n] = gg[level][n]
                        | (gp[level][n] & gg[level][n-(1 << level)]);
                end else begin : passthrough
                    assign gp[level+1][n] = gp[level][n];
                    assign gg[level+1][n] = gg[level][n];
                end
            end
        end
    endgenerate
endmodule
