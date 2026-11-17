module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] p;
    wire [WIDTH-1:0] c_add, c_ab, c_ba;
    wire [WIDTH-1:0] r_add, r_ab, r_ba;
    wire sel_add, sel_ab, sel_ba;
    wire sel_or, sel_and, sel_xor, sel_xnor;

    assign p = a ^ b;

    pw_alu_carry4 #(.WIDTH(WIDTH)) add_carries (
        .p(p), .g(a & b), .carry(c_add)
    );
    pw_alu_carry4 #(.WIDTH(WIDTH)) ab_borrows (
        .p(~p), .g((~a) & b), .carry(c_ab)
    );
    pw_alu_carry4 #(.WIDTH(WIDTH)) ba_borrows (
        .p(~p), .g(a & (~b)), .carry(c_ba)
    );

    assign r_add = p ^ c_add;
    assign r_ab = p ^ c_ab;
    assign r_ba = p ^ c_ba;

    assign sel_add  = (Oper == 3'b000);
    assign sel_ab   = (Oper == 3'b001);
    assign sel_ba   = (Oper == 3'b010);
    assign sel_or   = (Oper == 3'b011);
    assign sel_and  = (Oper == 3'b100);
    assign sel_xor  = (Oper == 3'b101);
    assign sel_xnor = (Oper == 3'b110);

    always @* begin
        sum = ({WIDTH{sel_add}}  & r_add)
            | ({WIDTH{sel_ab}}   & r_ab)
            | ({WIDTH{sel_ba}}   & r_ba)
            | ({WIDTH{sel_or}}   & (a | b))
            | ({WIDTH{sel_and}}  & (a & b))
            | ({WIDTH{sel_xor}}  & p)
            | ({WIDTH{sel_xnor}} & (~p));
    end
endmodule

module pw_alu_carry4 #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] p,
    input wire [WIDTH-1:0] g,
    output wire [WIDTH-1:0] carry
);
    localparam GROUPS = (WIDTH + 3) / 4;
    localparam PAD_WIDTH = 4 * GROUPS;
    localparam LEVELS = $clog2(GROUPS);

    wire [PAD_WIDTH-1:0] pp, gg;
    wire [PAD_WIDTH-1:0] cc;
    wire [GROUPS-1:0] group_p [0:LEVELS];
    wire [GROUPS-1:0] group_g [0:LEVELS];
    wire [GROUPS:0] boundary;

    assign pp[WIDTH-1:0] = p;
    assign gg[WIDTH-1:0] = g;
    generate
        if (PAD_WIDTH > WIDTH) begin : padding
            assign pp[PAD_WIDTH-1:WIDTH] = {(PAD_WIDTH-WIDTH){1'b1}};
            assign gg[PAD_WIDTH-1:WIDTH] = {(PAD_WIDTH-WIDTH){1'b0}};
        end
    endgenerate

    assign boundary[0] = 1'b0;
    genvar k, s, j;
    generate
        for (k = 0; k < GROUPS; k = k + 1) begin : blocks
            localparam B = 4*k;
            assign group_p[0][k] = pp[B+3] & pp[B+2] & pp[B+1] & pp[B];
            assign group_g[0][k] = gg[B+3]
                | (pp[B+3] & gg[B+2])
                | (pp[B+3] & pp[B+2] & gg[B+1])
                | (pp[B+3] & pp[B+2] & pp[B+1] & gg[B]);

            assign boundary[k+1] = group_g[LEVELS][k];
            assign cc[B] = boundary[k];
            assign cc[B+1] = gg[B] | (pp[B] & boundary[k]);
            assign cc[B+2] = gg[B+1]
                | (pp[B+1] & gg[B])
                | (pp[B+1] & pp[B] & boundary[k]);
            assign cc[B+3] = gg[B+2]
                | (pp[B+2] & gg[B+1])
                | (pp[B+2] & pp[B+1] & gg[B])
                | (pp[B+2] & pp[B+1] & pp[B] & boundary[k]);
        end
        for (s = 0; s < LEVELS; s = s + 1) begin : prefix_levels
            for (j = 0; j < GROUPS; j = j + 1) begin : prefix_nodes
                if (j >= (1 << s)) begin : combine
                    assign group_p[s+1][j] = group_p[s][j] & group_p[s][j-(1 << s)];
                    assign group_g[s+1][j] = group_g[s][j]
                        | (group_p[s][j] & group_g[s][j-(1 << s)]);
                end else begin : pass_through
                    assign group_p[s+1][j] = group_p[s][j];
                    assign group_g[s+1][j] = group_g[s][j];
                end
            end
        end
    endgenerate
    assign carry = cc[WIDTH-1:0];
endmodule
