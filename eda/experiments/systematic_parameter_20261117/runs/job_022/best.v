module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    wire [WIDTH-1:0] px = a ^ b;
    wire [WIDTH-1:0] eqp = ~px;
    wire [WIDTH-1:0] ga = a & b;
    wire [WIDTH-1:0] gab = (~a) & b;
    wire [WIDTH-1:0] gba = a & (~b);
    wire [WIDTH-1:0] ca, bab, bba;
    wire [WIDTH-1:0] add_result = px ^ ca;
    wire [WIDTH-1:0] ab_result = px ^ bab;
    wire [WIDTH-1:0] ba_result = px ^ bba;

    pw_alu_carry4 #(.WIDTH(WIDTH)) u_add (.p(px), .g(ga), .c(ca));
    pw_alu_carry4 #(.WIDTH(WIDTH)) u_ab (.p(eqp), .g(gab), .c(bab));
    pw_alu_carry4 #(.WIDTH(WIDTH)) u_ba (.p(eqp), .g(gba), .c(bba));

    wire s_add = (Oper == 3'b000);
    wire s_ab  = (Oper == 3'b001);
    wire s_ba  = (Oper == 3'b010);
    wire s_or  = (Oper == 3'b011);
    wire s_and = (Oper == 3'b100);
    wire s_xor = (Oper == 3'b101);
    wire s_xnr = (Oper == 3'b110);

    always @* begin
        sum = ({WIDTH{s_add}} & add_result)
            | ({WIDTH{s_ab}}  & ab_result)
            | ({WIDTH{s_ba}}  & ba_result)
            | ({WIDTH{s_or}}  & (a | b))
            | ({WIDTH{s_and}} & ga)
            | ({WIDTH{s_xor}} & px)
            | ({WIDTH{s_xnr}} & eqp);
    end
endmodule

module pw_alu_carry4 #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] p,
    input wire [WIDTH-1:0] g,
    output wire [WIDTH-1:0] c
);
    localparam GROUPS = (WIDTH + 3) / 4;
    localparam LEVELS = $clog2(GROUPS);
    localparam PAD = GROUPS * 4;
    wire [PAD-1:0] pp, gg;
    wire [GROUPS-1:0] gp [0:LEVELS];
    wire [GROUPS-1:0] gg_prefix [0:LEVELS];
    wire [GROUPS-1:0] boundary;

    genvar i, k, l;
    generate
        for (i = 0; i < PAD; i = i + 1) begin: pad_bits
            if (i < WIDTH) begin: real_bit
                assign pp[i] = p[i];
                assign gg[i] = g[i];
            end else begin: unused_bit
                assign pp[i] = 1'b1;
                assign gg[i] = 1'b0;
            end
        end
        for (k = 0; k < GROUPS; k = k + 1) begin: group_terms
            assign gp[0][k] = &pp[4*k +: 4];
            assign gg_prefix[0][k] = gg[4*k+3]
                | (pp[4*k+3] & gg[4*k+2])
                | (pp[4*k+3] & pp[4*k+2] & gg[4*k+1])
                | (pp[4*k+3] & pp[4*k+2] & pp[4*k+1] & gg[4*k]);
        end
        for (l = 0; l < LEVELS; l = l + 1) begin: prefix_level
            for (k = 0; k < GROUPS; k = k + 1) begin: prefix_node
                if (k >= (1 << l)) begin: combine
                    assign gp[l+1][k] = gp[l][k] & gp[l][k-(1 << l)];
                    assign gg_prefix[l+1][k] = gg_prefix[l][k]
                        | (gp[l][k] & gg_prefix[l][k-(1 << l)]);
                end else begin: pass_through
                    assign gp[l+1][k] = gp[l][k];
                    assign gg_prefix[l+1][k] = gg_prefix[l][k];
                end
            end
        end
        for (k = 0; k < GROUPS; k = k + 1) begin: group_boundary
            if (k == 0) begin: first
                assign boundary[k] = 1'b0;
            end else begin: later
                assign boundary[k] = gg_prefix[LEVELS][k-1];
            end
        end
        for (i = 0; i < WIDTH; i = i + 1) begin: bit_carry
            if ((i % 4) == 0) begin: offset0
                assign c[i] = boundary[i/4];
            end else if ((i % 4) == 1) begin: offset1
                assign c[i] = gg[i-1] | (pp[i-1] & boundary[i/4]);
            end else if ((i % 4) == 2) begin: offset2
                assign c[i] = gg[i-1]
                    | (pp[i-1] & gg[i-2])
                    | (pp[i-1] & pp[i-2] & boundary[i/4]);
            end else begin: offset3
                assign c[i] = gg[i-1]
                    | (pp[i-1] & gg[i-2])
                    | (pp[i-1] & pp[i-2] & gg[i-3])
                    | (pp[i-1] & pp[i-2] & pp[i-3] & boundary[i/4]);
            end
        end
    endgenerate
endmodule
