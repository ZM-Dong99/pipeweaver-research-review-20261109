module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] p, np;
    wire [WIDTH-1:0] ga, gab, gba;
    wire [WIDTH-1:0] ca, cab, cba;
    wire [WIDTH-1:0] add_result, ab_result, ba_result;
    wire sel_add, sel_ab, sel_ba, sel_or, sel_and, sel_xor, sel_xnor;

    assign p = a ^ b;
    assign np = ~p;
    assign ga = a & b;
    assign gab = a & ~b;
    assign gba = b & ~a;

    pw_alu_carry4 #(.WIDTH(WIDTH)) u_add (
        .p(p), .g(ga), .ci(1'b0), .carry(ca)
    );
    pw_alu_carry4 #(.WIDTH(WIDTH)) u_ab (
        .p(np), .g(gab), .ci(1'b1), .carry(cab)
    );
    pw_alu_carry4 #(.WIDTH(WIDTH)) u_ba (
        .p(np), .g(gba), .ci(1'b1), .carry(cba)
    );

    assign add_result = p ^ ca;
    assign ab_result = np ^ cab;
    assign ba_result = np ^ cba;
    assign sel_add = (Oper == 3'b000);
    assign sel_ab = (Oper == 3'b001);
    assign sel_ba = (Oper == 3'b010);
    assign sel_or = (Oper == 3'b011);
    assign sel_and = (Oper == 3'b100);
    assign sel_xor = (Oper == 3'b101);
    assign sel_xnor = (Oper == 3'b110);

    always @* begin
        sum = ({WIDTH{sel_add}} & add_result)
            | ({WIDTH{sel_ab}} & ab_result)
            | ({WIDTH{sel_ba}} & ba_result)
            | ({WIDTH{sel_or}} & (a | b))
            | ({WIDTH{sel_and}} & ga)
            | ({WIDTH{sel_xor}} & p)
            | ({WIDTH{sel_xnor}} & np);
    end
endmodule

module pw_alu_carry4 #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] p,
    input wire [WIDTH-1:0] g,
    input wire ci,
    output wire [WIDTH-1:0] carry
);
    localparam GROUPS = (WIDTH + 3) / 4;
    localparam PAD = 4 * GROUPS;
    localparam LEVELS = $clog2(GROUPS);
    wire [PAD-1:0] pp, gg;
    wire [GROUPS-1:0] group_p, group_g;
    wire [GROUPS-1:0] prefix_p [0:LEVELS];
    wire [GROUPS-1:0] prefix_g [0:LEVELS];
    wire [GROUPS-1:0] group_ci;
    wire [PAD-1:0] all_carry;

    genvar i, k, s;
    generate
        for (i = 0; i < PAD; i = i + 1) begin : pad_bits
            if (i < WIDTH) begin : valid_bit
                assign pp[i] = p[i];
                assign gg[i] = g[i];
            end else begin : unused_bit
                assign pp[i] = 1'b1;
                assign gg[i] = 1'b0;
            end
        end
        for (k = 0; k < GROUPS; k = k + 1) begin : groups
            assign group_p[k] = &pp[4*k +: 4];
            assign group_g[k] = gg[4*k+3]
                | (pp[4*k+3] & gg[4*k+2])
                | (pp[4*k+3] & pp[4*k+2] & gg[4*k+1])
                | (pp[4*k+3] & pp[4*k+2] & pp[4*k+1] & gg[4*k]);
            if (k == 0) begin : first_group
                assign group_ci[k] = ci;
            end else begin : later_group
                assign group_ci[k] = prefix_g[LEVELS][k-1]
                    | (prefix_p[LEVELS][k-1] & ci);
            end
            assign all_carry[4*k] = group_ci[k];
            assign all_carry[4*k+1] = gg[4*k]
                | (pp[4*k] & group_ci[k]);
            assign all_carry[4*k+2] = gg[4*k+1]
                | (pp[4*k+1] & gg[4*k])
                | (pp[4*k+1] & pp[4*k] & group_ci[k]);
            assign all_carry[4*k+3] = gg[4*k+2]
                | (pp[4*k+2] & gg[4*k+1])
                | (pp[4*k+2] & pp[4*k+1] & gg[4*k])
                | (pp[4*k+2] & pp[4*k+1] & pp[4*k] & group_ci[k]);
        end
    endgenerate

    assign prefix_p[0] = group_p;
    assign prefix_g[0] = group_g;
    generate
        for (s = 0; s < LEVELS; s = s + 1) begin : prefix_levels
            for (k = 0; k < GROUPS; k = k + 1) begin : prefix_columns
                if (k >= (1 << s)) begin : combine
                    assign prefix_p[s+1][k] = prefix_p[s][k]
                        & prefix_p[s][k-(1 << s)];
                    assign prefix_g[s+1][k] = prefix_g[s][k]
                        | (prefix_p[s][k] & prefix_g[s][k-(1 << s)]);
                end else begin : pass_through
                    assign prefix_p[s+1][k] = prefix_p[s][k];
                    assign prefix_g[s+1][k] = prefix_g[s][k];
                end
            end
        end
    endgenerate
    assign carry = all_carry[WIDTH-1:0];
endmodule
