module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] axb;
    wire [63:0] add_result, ab_result, ba_result;
    assign axb = a ^ b;

    alu64_group_prefix add_path (
        .p(axb), .g(a & b), .cin(1'b0), .s(add_result)
    );
    alu64_group_prefix ab_path (
        .p(~axb), .g(a & ~b), .cin(1'b1), .s(ab_result)
    );
    alu64_group_prefix ba_path (
        .p(~axb), .g(b & ~a), .cin(1'b1), .s(ba_result)
    );

    always @(*) begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = ab_result;
            3'b010: sum = ba_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = axb;
            3'b110: sum = ~axb;
            default: sum = 64'b0;
        endcase
    end
endmodule

module alu64_group_prefix (
    input [63:0] p,
    input [63:0] g,
    input cin,
    output [63:0] s
);
    wire [15:0] gp, gg;
    wire [15:0] p1, g1, p2, g2, p4, g4, p8, g8;
    wire [16:0] boundary;
    wire [63:0] carry;

    assign boundary[0] = cin;

    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : groups
            assign gp[k] = &p[4*k +: 4];
            assign gg[k] = g[4*k+3]
                         | (p[4*k+3] & g[4*k+2])
                         | (p[4*k+3] & p[4*k+2] & g[4*k+1])
                         | (p[4*k+3] & p[4*k+2] & p[4*k+1] & g[4*k]);

            if (k >= 1) begin : level1
                assign p1[k] = gp[k] & gp[k-1];
                assign g1[k] = gg[k] | (gp[k] & gg[k-1]);
            end else begin : pass1
                assign p1[k] = gp[k];
                assign g1[k] = gg[k];
            end

            if (k >= 2) begin : level2
                assign p2[k] = p1[k] & p1[k-2];
                assign g2[k] = g1[k] | (p1[k] & g1[k-2]);
            end else begin : pass2
                assign p2[k] = p1[k];
                assign g2[k] = g1[k];
            end

            if (k >= 4) begin : level4
                assign p4[k] = p2[k] & p2[k-4];
                assign g4[k] = g2[k] | (p2[k] & g2[k-4]);
            end else begin : pass4
                assign p4[k] = p2[k];
                assign g4[k] = g2[k];
            end

            if (k >= 8) begin : level8
                assign p8[k] = p4[k] & p4[k-8];
                assign g8[k] = g4[k] | (p4[k] & g4[k-8]);
            end else begin : pass8
                assign p8[k] = p4[k];
                assign g8[k] = g4[k];
            end

            assign boundary[k+1] = g8[k] | (p8[k] & cin);
            assign carry[4*k] = boundary[k];
            assign carry[4*k+1] = g[4*k]
                                      | (p[4*k] & boundary[k]);
            assign carry[4*k+2] = g[4*k+1]
                                      | (p[4*k+1] & g[4*k])
                                      | (p[4*k+1] & p[4*k] & boundary[k]);
            assign carry[4*k+3] = g[4*k+2]
                                      | (p[4*k+2] & g[4*k+1])
                                      | (p[4*k+2] & p[4*k+1] & g[4*k])
                                      | (p[4*k+2] & p[4*k+1] & p[4*k] & boundary[k]);
        end
    endgenerate

    assign s = p ^ carry;
endmodule
