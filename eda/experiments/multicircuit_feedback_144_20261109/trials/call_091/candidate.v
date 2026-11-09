module mul_subexpression(
    input [7:0] multiplicand,
    input [7:0] multiplier,
    output [15:0] product
);
    // Each column descriptor contains its height, full-adder count,
    // and half-adder count in bits [3:0], [7:4], and [8].
    function automatic [255:0] initial_table;
        integer c;
        integer h;
        begin
            initial_table = 256'b0;
            for (c = 0; c < 16; c = c + 1) begin
                if (c < 8) h = c + 1;
                else if (c < 15) h = 15 - c;
                else h = 0;
                initial_table[c*16 +: 4] = h;
            end
        end
    endfunction

    function automatic [255:0] reduce_table;
        input [255:0] previous;
        input integer target;
        integer c;
        integer h;
        integer incoming;
        integer excess;
        integer nf;
        integer nh;
        begin
            reduce_table = 256'b0;
            incoming = 0;
            for (c = 0; c < 16; c = c + 1) begin
                h = previous[c*16 +: 4];
                excess = h + incoming - target;
                if (excess > 0) begin
                    nf = excess / 2;
                    nh = excess % 2;
                end else begin
                    nf = 0;
                    nh = 0;
                end
                reduce_table[c*16 +: 4] = h + incoming - 2*nf - nh;
                reduce_table[c*16+4 +: 4] = nf;
                reduce_table[c*16+8] = nh;
                incoming = nf + nh;
            end
        end
    endfunction

    localparam [255:0] T0 = initial_table();
    localparam [255:0] T1 = reduce_table(T0, 6);
    localparam [255:0] T2 = reduce_table(T1, 4);
    localparam [255:0] T3 = reduce_table(T2, 3);
    localparam [255:0] T4 = reduce_table(T3, 2);

    wire [7:0] column [0:4][0:15];
    wire [7:0] carry_column [0:3][0:15];
    genvar c, k, s;
    generate
        for (c = 0; c < 16; c = c + 1) begin: partial_columns
            localparam integer H = T0[c*16 +: 4];
            for (k = 0; k < 8; k = k + 1) begin: bits_in_column
                if (k < H) begin: used
                    localparam integer R = (c < 8) ? k : c - 7 + k;
                    assign column[0][c][k] = multiplicand[R] & multiplier[c-R];
                end else begin: unused
                    assign column[0][c][k] = 1'b0;
                end
            end
        end
        for (s = 0; s < 4; s = s + 1) begin: reduction
            localparam [255:0] BEFORE = (s == 0) ? T0 : (s == 1) ? T1 : (s == 2) ? T2 : T3;
            localparam [255:0] AFTER = (s == 0) ? T1 : (s == 1) ? T2 : (s == 2) ? T3 : T4;
            for (c = 0; c < 16; c = c + 1) begin: columns
                localparam integer H = BEFORE[c*16 +: 4];
                localparam integer F = AFTER[c*16+4 +: 4];
                localparam integer A = AFTER[c*16+8];
                localparam integer CI = (c == 0) ? 0 : ((AFTER >> ((c-1)*16+4)) & 15) + ((AFTER >> ((c-1)*16+8)) & 1);
                localparam integer OUT_H = AFTER[c*16 +: 4];
                for (k = 0; k < 8; k = k + 1) begin: outputs
                    if (k < F) begin: full_carry
                        wire x;
                        assign x = column[s][c][3*k] ^ column[s][c][3*k+1];
                        assign carry_column[s][c][k] = (column[s][c][3*k] & column[s][c][3*k+1]) | (x & column[s][c][3*k+2]);
                    end else if (k < F+A) begin: half_carry
                        assign carry_column[s][c][k] = column[s][c][3*F] & column[s][c][3*F+1];
                    end else begin: no_carry
                        assign carry_column[s][c][k] = 1'b0;
                    end
                    if (k < CI) begin: incoming
                        if (c > 0) begin: valid_column
                            assign column[s+1][c][k] = carry_column[s][c-1][k];
                        end else begin: first_column
                            assign column[s+1][c][k] = 1'b0;
                        end
                    end else if (k < CI+F) begin: full_sum
                        localparam integer B = 3*(k-CI);
                        assign column[s+1][c][k] = column[s][c][B] ^ column[s][c][B+1] ^ column[s][c][B+2];
                    end else if (k < CI+F+A) begin: half_sum
                        assign column[s+1][c][k] = column[s][c][3*F] ^ column[s][c][3*F+1];
                    end else if (k < OUT_H) begin: forwarded
                        localparam integer B = 3*F + 2*A + k - CI - F - A;
                        assign column[s+1][c][k] = column[s][c][B];
                    end else begin: padding
                        assign column[s+1][c][k] = 1'b0;
                    end
                end
            end
        end
    endgenerate

    wire [15:0] a, b;
    wire [15:0] propagate [0:4];
    wire [15:0] generate_carry [0:4];
    generate
        for (c = 0; c < 16; c = c + 1) begin: final_rows
            assign a[c] = column[4][c][0];
            assign b[c] = column[4][c][1];
        end
    endgenerate
    assign propagate[0] = a ^ b;
    assign generate_carry[0] = a & b;
    generate
        for (s = 0; s < 4; s = s + 1) begin: prefix_levels
            for (c = 0; c < 16; c = c + 1) begin: prefix_bits
                if (c >= (1 << s)) begin: combine
                    assign propagate[s+1][c] = propagate[s][c] & propagate[s][c-(1 << s)];
                    assign generate_carry[s+1][c] = generate_carry[s][c] | (propagate[s][c] & generate_carry[s][c-(1 << s)]);
                end else begin: pass
                    assign propagate[s+1][c] = propagate[s][c];
                    assign generate_carry[s+1][c] = generate_carry[s][c];
                end
            end
        end
        for (c = 0; c < 16; c = c + 1) begin: result_bits
            if (c == 0) begin: low_bit
                assign product[c] = propagate[0][c];
            end else begin: other_bits
                assign product[c] = propagate[0][c] ^ generate_carry[4][c-1];
            end
        end
    endgenerate
endmodule
