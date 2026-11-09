module alu_64bit(
    input [63:0] a, b,
    input [2:0] Oper,
    output reg [63:0] sum
);
    wire [63:0] px;
    wire [63:0] add_result, ab_result, ba_result;
    wire [63:0] ga, gab, gba;

    assign px = a ^ b;
    assign ga = a & b;
    assign gab = a & ~b;
    assign gba = b & ~a;

    alu64_cla_core #(.CIN(1'b0)) add_core (
        .p(px), .g(ga), .s(add_result)
    );
    alu64_cla_core #(.CIN(1'b1)) ab_core (
        .p(~px), .g(gab), .s(ab_result)
    );
    alu64_cla_core #(.CIN(1'b1)) ba_core (
        .p(~px), .g(gba), .s(ba_result)
    );

    always @(*) begin
        case (Oper)
            3'b000: sum = add_result;
            3'b001: sum = ab_result;
            3'b010: sum = ba_result;
            3'b011: sum = a | b;
            3'b100: sum = a & b;
            3'b101: sum = px;
            3'b110: sum = ~px;
            default: sum = 64'b0;
        endcase
    end
endmodule

module alu64_cla_core #(
    parameter CIN = 1'b0
)(
    input [63:0] p,
    input [63:0] g,
    output [63:0] s
);
    wire [15:0] gp, gg;
    wire [3:0] sp, sg;
    wire [3:0] sc;
    wire [15:0] bc;
    wire [63:0] c;
    genvar i, j;

    generate
        for (i = 0; i < 16; i = i + 1) begin: groups
            assign gp[i] = &p[4*i +: 4];
            assign gg[i] = g[4*i+3]
                         | (p[4*i+3] & g[4*i+2])
                         | (p[4*i+3] & p[4*i+2] & g[4*i+1])
                         | (p[4*i+3] & p[4*i+2] & p[4*i+1] & g[4*i]);

            assign c[4*i] = bc[i];
            assign c[4*i+1] = g[4*i]
                            | (p[4*i] & bc[i]);
            assign c[4*i+2] = g[4*i+1]
                            | (p[4*i+1] & g[4*i])
                            | (p[4*i+1] & p[4*i] & bc[i]);
            assign c[4*i+3] = g[4*i+2]
                            | (p[4*i+2] & g[4*i+1])
                            | (p[4*i+2] & p[4*i+1] & g[4*i])
                            | (p[4*i+2] & p[4*i+1] & p[4*i] & bc[i]);
        end

        for (j = 0; j < 4; j = j + 1) begin: supergroups
            assign sp[j] = &gp[4*j +: 4];
            assign sg[j] = gg[4*j+3]
                         | (gp[4*j+3] & gg[4*j+2])
                         | (gp[4*j+3] & gp[4*j+2] & gg[4*j+1])
                         | (gp[4*j+3] & gp[4*j+2] & gp[4*j+1] & gg[4*j]);

            assign bc[4*j] = sc[j];
            assign bc[4*j+1] = gg[4*j]
                             | (gp[4*j] & sc[j]);
            assign bc[4*j+2] = gg[4*j+1]
                             | (gp[4*j+1] & gg[4*j])
                             | (gp[4*j+1] & gp[4*j] & sc[j]);
            assign bc[4*j+3] = gg[4*j+2]
                             | (gp[4*j+2] & gg[4*j+1])
                             | (gp[4*j+2] & gp[4*j+1] & gg[4*j])
                             | (gp[4*j+2] & gp[4*j+1] & gp[4*j] & sc[j]);
        end
    endgenerate

    assign sc[0] = CIN;
    assign sc[1] = sg[0] | (sp[0] & CIN);
    assign sc[2] = sg[1]
                 | (sp[1] & sg[0])
                 | (sp[1] & sp[0] & CIN);
    assign sc[3] = sg[2]
                 | (sp[2] & sg[1])
                 | (sp[2] & sp[1] & sg[0])
                 | (sp[2] & sp[1] & sp[0] & CIN);

    assign s = p ^ c;
endmodule
