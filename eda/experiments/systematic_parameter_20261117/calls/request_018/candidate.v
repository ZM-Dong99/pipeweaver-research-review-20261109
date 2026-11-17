module pw_alu #(
    parameter WIDTH = 64
)(
    input wire [WIDTH-1:0] a, b,
    input wire [2:0] Oper,
    output reg [WIDTH-1:0] sum
);
    localparam GROUPS = (WIDTH + 3) / 4;
    localparam PAD = GROUPS * 4;
    localparam LEVELS = $clog2(GROUPS);

    wire sub_ab = (Oper == 3'b001);
    wire sub_ba = (Oper == 3'b010);
    wire subtract = sub_ab | sub_ba;
    wire arithmetic = (Oper == 3'b000) | sub_ab | sub_ba;
    wire select_or = (Oper == 3'b011);
    wire select_and = (Oper == 3'b100);
    wire select_xor = (Oper == 3'b101);
    wire select_xnor = (Oper == 3'b110);

    wire [WIDTH-1:0] bit_xor = a ^ b;
    wire [PAD-1:0] p, g;
    wire [GROUPS-1:0] prefix_p [0:LEVELS];
    wire [GROUPS-1:0] prefix_g [0:LEVELS];
    wire [WIDTH-1:0] arithmetic_result;
    wire [WIDTH-1:0] result;

    genvar i, k, s;
    generate
        for (i = 0; i < PAD; i = i + 1) begin: leaves
            if (i < WIDTH) begin: active
                assign p[i] = bit_xor[i] ^ subtract;
                assign g[i] = (a[i] ^ sub_ba) & (b[i] ^ sub_ab);
            end else begin: padding
                assign p[i] = 1'b1;
                assign g[i] = 1'b0;
            end
        end

        for (k = 0; k < GROUPS; k = k + 1) begin: groups
            wire [3:0] lp;
            wire [3:0] lg;
            wire [3:0] carry;
            assign lp = p[4*k +: 4];
            assign lg = g[4*k +: 4];
            assign prefix_p[0][k] = &lp;
            assign prefix_g[0][k] = lg[3]
                | (lp[3] & lg[2])
                | (lp[3] & lp[2] & lg[1])
                | (lp[3] & lp[2] & lp[1] & lg[0]);

            if (k == 0) begin: first
                assign carry[0] = subtract;
            end else begin: following
                assign carry[0] = prefix_g[LEVELS][k-1]
                    | (prefix_p[LEVELS][k-1] & subtract);
            end
            assign carry[1] = lg[0] | (lp[0] & carry[0]);
            assign carry[2] = lg[1] | (lp[1] & lg[0])
                | (lp[1] & lp[0] & carry[0]);
            assign carry[3] = lg[2] | (lp[2] & lg[1])
                | (lp[2] & lp[1] & lg[0])
                | (lp[2] & lp[1] & lp[0] & carry[0]);

            for (i = 0; i < 4; i = i + 1) begin: local_sum
                if (4*k+i < WIDTH) begin: active
                    assign arithmetic_result[4*k+i] = lp[i] ^ carry[i];
                end
            end
        end

        for (s = 0; s < LEVELS; s = s + 1) begin: prefix_levels
            for (k = 0; k < GROUPS; k = k + 1) begin: nodes
                if (k >= (1 << s)) begin: combine
                    assign prefix_g[s+1][k] = prefix_g[s][k]
                        | (prefix_p[s][k] & prefix_g[s][k-(1 << s)]);
                    assign prefix_p[s+1][k] = prefix_p[s][k]
                        & prefix_p[s][k-(1 << s)];
                end else begin: pass
                    assign prefix_g[s+1][k] = prefix_g[s][k];
                    assign prefix_p[s+1][k] = prefix_p[s][k];
                end
            end
        end

        for (i = 0; i < WIDTH; i = i + 1) begin: output_bits
            assign result[i] = (arithmetic & arithmetic_result[i])
                | (select_or & (a[i] | b[i]))
                | (select_and & (a[i] & b[i]))
                | (select_xor & bit_xor[i])
                | (select_xnor & ~bit_xor[i]);
        end
    endgenerate

    always @* begin
        sum = result;
    end
endmodule
